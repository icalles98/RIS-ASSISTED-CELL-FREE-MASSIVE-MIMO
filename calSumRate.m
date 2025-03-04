function sumRate = calSumRate(K, sigma2, u_k, H_lk, F)
% Calcula la tasa de transmisión total (sum-rate) en un sistema cell-free MIMO con RIS.
%
% Parámetros de entrada:
%   K       - Número de UEs (Usuarios)
%   sigma2  - Varianza del ruido
%   u_k     - Vector de combinación de los UEs (Nr, K)
%   H_lk    - Canal descendente (estructura con H_k)
%   F       - Matriz de precodificación en los APs
%
% Parámetro de salida:
%   sumRate - Tasa de transmisión total en el sistema

%% **1️ Inicialización del vector SINR**
SINR_k = zeros(K,1);  % Vector que almacenará el SINR de cada usuario

%% **2️ Cálculo del SINR para cada usuario**
for k = 1:K  % Para cada usuario
    
    % Inicializar la potencia total de interferencia
    sumPwr_K = 0;  

    % Calcular la interferencia total (incluyendo la señal deseada)
    for i = 1:K
        sumPwr_K = sumPwr_K + norm(u_k(:,k)' * H_lk.H_k(:,:,k)' * F.f_k(:,i))^2;
        % - `H_lk.H_k(:,:,k)' * F.f_k(:,i)`: Canal efectivo del AP al usuario `k` con precoding aplicado.
        % - `u_k(:,k)'`: Combinación de recepción en el UE `k`.
        % - `norm(...)^2`: Obtiene la potencia total en el enlace `i → k`.
    end

    % Potencia de la señal útil del usuario `k`
    pwr_k = norm(u_k(:,k)' * H_lk.H_k(:,:,k)' * F.f_k(:,k))^2;

    % Cálculo del SINR
    SINR_k(k) = pwr_k / (sumPwr_K - pwr_k + norm(u_k(:,k))^2 * sigma2);
    % - `sumPwr_K - pwr_k`: Representa la **interferencia total** de otros usuarios.
    % - `norm(u_k(:,k))^2 * sigma2`: Potencia del ruido en el UE `k`.
end

%% **3️ Cálculo de la tasa de transmisión total**
sumRate = sum(log2(1 + SINR_k));
% - `sum(...)`: Suma las tasas de todos los usuarios.

end
