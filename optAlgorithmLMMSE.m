function [u_k, F, Theta, sumRate] = optAlgorithmLMMSE(L, R, K, M, Nt, Nr, APpwr, sigma2, u_k, Hd_lk, h_rk, g_lr, F, Theta, Iter)
% Algoritmo de optimización LMMSE para cell-free massive MIMO con RIS.
%
% Parámetros de entrada:
%   L       - Número de APs (Puntos de Acceso)
%   R       - Número de RISs
%   K       - Número de UEs (Usuarios)
%   M       - Número de elementos en cada RIS
%   Nt      - Número de antenas en cada AP
%   Nr      - Número de antenas en cada UE
%   APpwr   - Potencia total de transmisión del AP (en vatios)
%   sigma2  - Varianza del ruido
%   u_k     - Vector de combinación de los UEs
%   Hd_lk   - Canal directo AP → UE
%   h_rk    - Canal RIS → UE
%   g_lr    - Canal AP → RIS
%   F       - Matriz de precodificación en los APs
%   Theta   - Matriz de fase de la RIS
%   Iter    - Número de iteraciones del algoritmo
%
% Parámetros de salida:
%   u_k     - Vector de combinación optimizado
%   F       - Matriz de precodificación optimizada
%   Theta   - Matriz de fase RIS optimizada
%   sumRate - Evolución de la tasa de transmisión total a lo largo de las iteraciones

% Inicialización del vector de tasas de transmisión por iteración
sumRate = zeros(Iter,1);

% Definición de la tasa de aprendizaje en cada iteración (valores empíricos)
alpha = [0.5, 0.2, 0.2, 0.1, 0.1, 0.18, ...
    0.15, 0.12, 0.1, 0.1, 0.08, 0.07, ...
    0.05, 0.02*ones(1,10), 0.01*ones(1,10), 0.005*ones(1,100)];

% **Iteración principal del algoritmo de optimización**
for iter = 1:Iter
    %% **1️ Generación del canal descendente**
    H_lk = channelGenerateDL(L, K, Nt, Nr, Hd_lk, h_rk, g_lr, Theta);
    % - `H_lk`: Canal efectivo considerando la RIS y su matriz de fase `Theta`.

    %% **2️ Cálculo de la tasa de transmisión total**
    sumRate(iter) = calSumRate(K, sigma2, u_k, H_lk, F);
    % - `calSumRate(...)` calcula la tasa de transmisión agregada usando la configuración actual.

    %% **3️ Optimización del vector de combinación de los UEs**
    u_k = optu_kBentch(K, Nr, sigma2, H_lk, F); 
    % - `optu_kBentch(...)` optimiza `u_k`, el vector de combinación de los UEs.
    % - `u_k` tiene tamaño **(Nr, K)** (una combinación por cada UE).

    %% **4️ Optimización de la matriz de precodificación en los APs**
    % Guardamos la matriz de precodificación de la iteración anterior
    F_before = F;

    % Aplicamos el algoritmo LMMSE para obtener una nueva matriz de precodificación
    F = optFLMMSE(L, K, Nt, H_lk, u_k, F, APpwr);
    % - `optFLMMSE(...)` optimiza `F` usando el criterio de mínima media cuadrática (LMMSE).
    % - `F.F` tiene tamaño **(L*Nt, K)**.

    % **Actualización de la precodificación con tasa de aprendizaje `alpha`**
    F.f_lk = (1-alpha(iter)) * F_before.f_lk + alpha(iter) * (F.f_lk);
    % - Se usa `alpha(iter)` para una actualización controlada del precoding, evitando cambios bruscos.

    % **Conversión de la matriz `F` a su nueva representación**
    F.f_k = matCovertflk2fk(L, K, Nt, F.f_lk);
    F.F = F.f_k;  % `F` se reorganiza en una matriz de tamaño **(L*Nt, K)**.

    %% **5️ Optimización de la matriz de fase de la RIS**
    Theta = optThetaBentch(L, R, K, M, Nt, u_k, Hd_lk, h_rk, g_lr, F);
    % - `optThetaBentch(...)` optimiza la matriz de fase `Theta`.
    % - `Theta.Theta` tiene tamaño **(MR, MR)**, donde **MR = M * R**.

end
end


