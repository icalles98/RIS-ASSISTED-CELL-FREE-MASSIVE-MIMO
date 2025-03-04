function F = optFLMMSE(L, K, Nt, H_lk, u_k, F, APpwr)
% Optimiza la matriz de precodificación en los APs (F) usando LMMSE con restricciones de potencia.
%
% Parámetros de entrada:
%   L       - Número de APs (Puntos de Acceso)
%   K       - Número de UEs (Usuarios)
%   Nt      - Número de antenas en cada AP
%   H_lk    - Canal descendente (estructura con H_k)
%   u_k     - Vector de combinación de los UEs
%   F       - Matriz de precodificación inicial en los APs
%   APpwr   - Potencia total de transmisión del AP (en vatios)
%
% Parámetro de salida:
%   F       - Matriz de precodificación optimizada

%% **1️ Inicialización de la Matriz de Precoding**
F.f_lk = zeros(Nt, L, K);

%% **2️ Cálculo de la Matriz Auxiliar `B`**
B = matrixGenerateB(L, K, Nt, H_lk, u_k);
% - `B.b_lk`: Matriz de tamaño **(Nt, L, K)**, relacionada con el canal y la combinación de los UEs.
% - `B.b_k`: Matriz consolidada **(L*Nt, K)**.
% - `B.B`: Matriz de correlación del canal **(L*Nt, K)**.

%% **3️ Cálculo de la Matriz `Lambda`**
Lambda = matrixGenerateLambda(L, K, Nt, B);
% - `Lambda`: Matriz de tamaño **(L*Nt, L*Nt)** usada para regularizar la solución.


%% **4️ Búsqueda del Factor `lambda` para Cumplir la Restricción de Potencia**
% Se usa el **método de bisección** para encontrar `lambda` tal que la potencia transmitida **no supere `APpwr`**.

for l = 1:L  % Para cada AP
    
    % Parámetros del método de bisección
    errth = 1e-6;   % Umbral de error aceptable
    errVal = 1;     % Inicialización del error
    lower = 1e-6;   % Límite inferior para lambda
    upper = 1e6;    % Límite superior para lambda

    % Iteración de búsqueda binaria hasta encontrar lambda
    while (abs(errVal) > errth) && (upper >= errth)
        lambda = (lower + upper) / 2;
        
        % Calcular F.f_lk para este lambda
        for k = 1:K
            F.f_lk(:,l,k) = (Lambda((l-1)*Nt+1:l*Nt, (l-1)*Nt+1:l*Nt) + lambda * eye(Nt))^(-1) * (B.b_lk(:,l,k));
        end

        % Evaluar la potencia total
        errVal = norm(reshape(F.f_lk(:,l,:), Nt, K))^2 - APpwr;
        
        % Ajustar el intervalo de búsqueda
        if errVal > 0
            lower = lambda;  % Aumentar lambda
        else
            upper = lambda;  % Disminuir lambda
        end
    end
end
