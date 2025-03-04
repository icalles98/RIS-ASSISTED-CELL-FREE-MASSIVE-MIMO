function Sigma = matrixGenerateSigma(L, R, K, M, F, d_lk)
% Genera la matriz Sigma, utilizada en la optimización de la RIS (Theta).
%
% Parámetros de entrada:
%   L       - Número de APs (Puntos de Acceso)
%   R       - Número de RISs
%   K       - Número de UEs (Usuarios)
%   M       - Número de elementos en cada RIS
%   F       - Matriz de precodificación en los APs
%   d_lk    - Matriz auxiliar que representa el canal reflejado modificado por la RIS
%
% Parámetro de salida:
%   Sigma   - Matriz de correlación de interferencia en la RIS (M*R, M*R)

%% **1️ Inicialización de `Sigma` y `sumTemp`**
Sigma = zeros(M * R, M * R);
sumTemp = zeros(M * R, 1);
% - `Sigma`: Matriz de correlación de interferencia en la RIS, tamaño **(M*R, M*R)**.
% - `sumTemp`: Vector temporal usado para acumular señales reflejadas.

%% **2️ Cálculo de `Sigma` Sumando la Interferencia de Todos los Usuarios**
for k = 1:K  % Para cada usuario
    for i = 1:K  % Para cada usuario interferente
        for l = 1:L  % Para cada AP
            sumTemp = sumTemp + d_lk(:,:,l,k) * F.f_lk(:,l,i);
            % - `d_lk(:,:,l,k)`: Canal reflejado AP → RIS → UE `k` desde el AP `l`.
            % - `F.f_lk(:,l,i)`: Vector de precodificación del usuario `i` en el AP `l`.
            % - `sumTemp`: Acumula la señal reflejada en la RIS para el usuario `k` por cada AP `l`.
        end
        Sigma = Sigma + sumTemp * sumTemp';
        % - `sumTemp * sumTemp'`: Producto externo para obtener la correlación de interferencia.
        % - `Sigma`: Acumula la interferencia total en la RIS considerando todos los usuarios `k` y `i`.
        
        sumTemp = zeros(M * R, 1);  % Reiniciar `sumTemp` para el siguiente usuario `i`.
    end
end

end
