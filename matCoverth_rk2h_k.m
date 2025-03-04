function h_k = matCoverth_rk2h_k(R, K, M, Nr, h_rk)
% h_rk - Matriz de entrada de tamaño (M, Nr, R, K)
% h_k  - Matriz de salida de tamaño (M*R, Nr, K), reorganizando RISs en una sola dimensión
%
% Parámetros de entrada:
%   R     - Número de RISs
%   K     - Número de usuarios (UEs)
%   M     - Número de elementos en cada RIS
%   Nr    - Número de antenas en el UE
%   h_rk  - Matriz de canal RIS → UE con dimensiones (M, Nr, R, K)
%
% Parámetro de salida:
%   h_k   - Matriz de canal RIS → UE reorganizada con tamaño (M*R, Nr, K)

% Inicialización de la matriz de salida con ceros
h_k = zeros(M * R, Nr, K);

% Reorganización de la matriz de entrada en la nueva estructura
for r = 1:R  % Para cada RIS
    for k = 1:K  % Para cada usuario (UE)
        % Asigna los valores de h_rk a la nueva matriz h_k
        % Para el RIS r, sus M elementos se colocan en una sección de tamaño (M, Nr)
        h_k((r-1)*M+1:r*M, :, k) = h_rk(:,:,r,k);  
    end
end
end
