function [u_k, F, Theta, sumRate] = optAlgorithmNoRIS(L, R, K, M, Nt, Nr, APpwr, sigma2, u_k, Hd_lk, h_rk, g_lr, F, Theta, Iter)
% Algoritmo de optimización sin RIS para un sistema cell-free massive MIMO.
%
% Parámetros de entrada:
%   L       - Número de APs (Puntos de Acceso)
%   R       - Número de RISs (NO SE USAN)
%   K       - Número de UEs (Usuarios)
%   M       - Número de elementos en cada RIS (NO SE USAN)
%   Nt      - Número de antenas en cada AP
%   Nr      - Número de antenas en cada UE
%   APpwr   - Potencia de transmisión en los APs (W)
%   sigma2  - Potencia del ruido
%   u_k     - Vector de combinación inicial en los UEs
%   Hd_lk   - Canal directo AP → UE
%   h_rk    - Canal RIS → UE (NO SE USA)
%   g_lr    - Canal AP → RIS (NO SE USA)
%   F       - Matriz de precodificación inicial en los APs
%   Theta   - Matriz de fase inicial de la RIS (Se pone a cero)
%   Iter    - Número de iteraciones de optimización
%
% Parámetro de salida:
%   u_k     - Vector de combinación optimizado en los UEs
%   F       - Matriz de precodificación optimizada en los APs
%   Theta   - Matriz de fase (Cero, porque la RIS no está presente)
%   sumRate - Vector con la suma de tasas de datos en cada iteración

%% **1️ Inicialización del Vector de Suma de Tasas**
sumRate = zeros(Iter, 1);
% - `sumRate(iter)`: Almacena la suma de tasas de datos en cada iteración.

%% **2️ Desactivación de la RIS (`Theta = 0`)**
Theta.Theta = zeros(M * R, M * R);
Theta.Theta_r = zeros(M, M, R);
Theta.Phi = zeros(1, M * R);
% - `Theta`: Matriz de fase de la RIS establecida en **cero**.
% - Esto significa que **no hay reflexión** de la RIS.

%% **3️ Iteraciones de Optimización**
for iter = 1:Iter  % Para cada iteración de optimización

    %% **3.1 Generación del Canal Descendente `H_lk` SIN RIS**
    H_lk = channelGenerateDL(L, K, Nt, Nr, Hd_lk, h_rk, g_lr, Theta);
    % - `H_lk`: Canal efectivo entre APs y UEs, pero sin reflejo de la RIS.

    %% **3.2 Cálculo de la Suma de Tasas de Datos**
    sumRate(iter) = calSumRate(K, sigma2, u_k, H_lk, F);
    % - `sumRate(iter)`: Calcula la capacidad total del sistema.

    %% **3.3 Optimización del Vector de Combinación `u_k`**
    u_k = optu_kBentch(K, Nr, sigma2, H_lk, F);
    % - `u_k`: Vector de combinación optimizado en los UEs.
    % - **Tamaño:** (Nr, K).

    %% **3.4 Optimización de la Matriz de Precoding `F`**
    F = optFBentch(L, K, Nt, APpwr, H_lk, u_k);
    % - `F`: Matriz de precodificación optimizada en los APs.
    % - **Tamaño:** (L*Nt, K).

    %% **3.5 (Opción Comentada) Optimización de la Matriz de Fase `Theta`**
    % Theta = optThetaBentch(L, R, K, M, Nt, u_k, Hd_lk, h_rk, g_lr, F);
    % - Esta línea está comentada porque **no se optimiza la RIS**.
end
end
