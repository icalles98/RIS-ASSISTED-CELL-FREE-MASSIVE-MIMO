clear all; 
clc;    

%% Definición de parámetros y generación del canal

Iter       = 20; % Número máximo de iteraciones del algoritmo de optimización

% Parámetros del AP (Puntos de Acceso)
L          = 5;       % Número de APs en la red
Nt         = 2;       % Número de antenas en cada AP
APpwr      = 1e-3;    % Potencia máxima de transmisión de cada AP en vatios (W)

% Parámetros de los Usuarios (UE - User Equipments)
K          = 4;       % Número de UEs en la red
Nr         = 1;       % Número de antenas en cada UE
UEpwr      = 1e-4;    % Potencia máxima de transmisión de cada UE en vatios (W)

% Parámetros del RIS (Superficie Inteligente Reconfigurable)
R          = 2;       % Número de RIS en la red
M          = 64;      % Número de elementos reflectores en cada RIS

% Parámetro de ruido
sigma2     = 1e-10;   % Varianza del ruido del canal

%% Generación de posiciones para los APs, RIS y UEs
[distAP2RIS, distAP2User, distRIS2User] = positionGenerate(L, K, R);

%% Generación de los canales de comunicación
% Se generan los canales entre APs, RIS y UEs basados en las distancias calculadas
[Hd_lk, h_rk, g_lr] = channelGenerate(L, R, K, M, Nt, Nr, distAP2RIS, distAP2User, distRIS2User); 

%% Inicialización de variables de optimización (vectores u, precodificación F, y matriz RIS Theta)
[u_k, F, Theta] = initOptVariable(L, R, K, M, Nt, Nr, APpwr, UEpwr);

%% Algoritmos de optimización propuestos

% Algoritmo basado en L-MMSE (Linear Minimum Mean Square Error)
[~, ~, ~, sumRateLMMSE] =  optAlgorithmLMMSE(L, R, K, M, Nt, Nr, APpwr, sigma2, u_k, Hd_lk, h_rk, g_lr, F, Theta, Iter);

% Algoritmo con RIS pero usando una matriz de fase aleatoria (sin optimización)
[~, ~, ~, sumRateRandTheta] =  optAlgorithmRandTheta(L, R, K, M, Nt, Nr, APpwr, sigma2, u_k, Hd_lk, h_rk, g_lr, F, Theta, Iter);

% Escenario sin RIS (para comparar el desempeño con y sin RIS)
[~, ~, ~, sumRateNoRIS] =  optAlgorithmNoRIS(L, R, K, M, Nt, Nr, APpwr, sigma2, u_k, Hd_lk, h_rk, g_lr, F, Theta, Iter);

%% Graficar resultados
figure, hold on, grid on
plot(sumRateLMMSE,'-o', 'MarkerSize', 8, 'LineWidth', 1.5);   % Grafica la tasa de suma del método L-MMSE
plot(sumRateNoRIS,'--', 'LineWidth', 1.5);   % Grafica la tasa de suma del sistema SIN RIS
plot(sumRateRandTheta, '-x', 'LineWidth', 1.5); % Grafica la tasa de suma del sistema con RIS aleatorio
xlabel('Number of iterations');
ylabel('Average sum-rate (bits/s/Hz)');
title('Average sum-rate vs. the number of iteration');
legend('LMMSE', 'Random Theta', 'No RIS');

