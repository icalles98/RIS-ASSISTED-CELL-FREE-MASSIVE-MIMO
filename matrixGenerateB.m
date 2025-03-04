function B = matrixGenerateB(L, K, Nt, H_lk, u_k)
% Genera la matriz B para la optimización de la precodificación en los APs.
%
% Parámetros de entrada:
%   L       - Número de APs (Puntos de Acceso)
%   K       - Número de UEs (Usuarios)
%   Nt      - Número de antenas en cada AP
%   H_lk    - Canal descendente (estructura con H_lk)
%   u_k     - Vector de combinación de los UEs
%
% Parámetro de salida:
%   B       - Estructura con las matrices:
%             - `B.b_lk`: Relación entre canal y vector de combinación (Nt, L, K)
%             - `B.b_k`: Matriz consolidada (L*Nt, K)
%             - `B.B`: Versión reorganizada de `B.b_k`

%% **1️ Inicialización de las Matrices de `B`**
B.b_lk = zeros(Nt, L, K);   % Matriz de tamaño (Nt, L, K)
B.b_k = zeros(L*Nt, K);     % Matriz de tamaño (L*Nt, K)

%% **2️ Cálculo de `B.b_lk` y `B.b_k`**
for l = 1:L  % Para cada AP
    for k = 1:K  % Para cada usuario
        B.b_lk(:,l,k) = H_lk.H_lk(:,:,l,k) * u_k(:,k);
        % - `H_lk.H_lk(:,:,l,k)`: Canal del AP `l` al usuario `k`.
        % - `u_k(:,k)`: Vector de combinación en el usuario `k`.
        % - El producto `H_lk * u_k` obtiene la señal procesada en el AP `l`.

        % Reorganización en una única matriz `B.b_k`
        B.b_k((l-1)*Nt+1:l*Nt,k) = B.b_lk(:,l,k);
        % - Se concatenan todas las antenas de los APs en una sola dimensión.
    end
end

%% **3️ Conversión de `B.b_k` a `B.B`**
B.B = B.b_k;  % `B.B` almacena la versión consolidada de `B.b_k`
end
