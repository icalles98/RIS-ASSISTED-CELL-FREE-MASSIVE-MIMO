function u_k = optu_kBentch(K, Nr, sigma2, H_lk, F)
% Optimiza el vector de combinación de los UEs (u_k) en un sistema cell-free MIMO con RIS.
%
% Parámetros de entrada:
%   K       - Número de UEs (Usuarios)
%   Nr      - Número de antenas en cada UE
%   sigma2  - Varianza del ruido
%   H_lk    - Canal descendente (estructura con H_k)
%   F       - Matriz de precodificación en los APs
%
% Parámetro de salida:
%   u_k     - Vector de combinación optimizado (Nr, K)

%% **1️ Inicialización del vector de combinación `u_k`**
u_k = zeros(Nr, K);

%% **2️ Cálculo de la matriz de interferencia `W_k`**
W_k = matrixGenerateW_k(K, Nr, H_lk, F);  
% - `W_k(:,:,k)`: Matriz de interferencia efectiva para el usuario `k`.
% - `W_k` tiene tamaño **(Nr, Nr, K)**.

%% **3️ Optimización del vector de combinación `u_k`**
for k = 1:K  % Para cada usuario

   % Cálculo del vector de combinación óptimo
   u_k(:,k) = (W_k(:,:,k) + sigma2 * eye(Nr))^(-1) * H_lk.H_k(:,:,k)' * F.f_k(:,k);
   % - `W_k(:,:,k)`: Representa la interferencia en el usuario `k`.
   % - `sigma2 * eye(Nr)`: Modela el ruido aditivo.
   % - `(W_k + sigma2*I)^(-1)`: Matriz inversa para mitigar interferencia y ruido.
   % - `H_lk.H_k(:,:,k)' * F.f_k(:,k)`: Modela la señal útil recibida.

end
end
