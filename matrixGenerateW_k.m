function W_k = matrixGenerateW_k(K, Nr, H_lk, F)
% Genera la matriz de interferencia W_k para cada usuario en un sistema cell-free MIMO con RIS.
%
% Parámetros de entrada:
%   K       - Número de UEs (Usuarios)
%   Nr      - Número de antenas en cada UE
%   H_lk    - Canal descendente (estructura con H_k)
%   F       - Matriz de precodificación en los APs
%
% Parámetro de salida:
%   W_k     - Matriz de interferencia para cada usuario (Nr, Nr, K)

%% **1️ Inicialización de la Matriz `W_k`**
W_k = zeros(Nr, Nr, K);
% - `W_k(:,:,k)`: Matriz de interferencia para el usuario `k`, tamaño **(Nr, Nr, K)**.

%% **2️ Cálculo de la Interferencia Multiusuario**
for k = 1:K  % Para cada usuario `k`
    for i = 1:K  % Para cada usuario interferente `i`
        W_k(:,:,k) = W_k(:,:,k) + (H_lk.H_k(:,:,k)' * F.f_k(:,i)) * (H_lk.H_k(:,:,k)' * F.f_k(:,i))';
        % - `H_lk.H_k(:,:,k)'`: Canal efectivo del AP al usuario `k`.
        % - `F.f_k(:,i)`: Vector de precodificación del usuario `i`.
        % - `(...) * (...)'`: Producto de matrices para obtener la interferencia total en `k`.
    end
end
end
