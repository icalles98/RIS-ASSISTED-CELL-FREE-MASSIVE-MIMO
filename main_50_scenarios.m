clear all; 
clc;    

%%
N_scenarios= 50; % Número de escenarios para MonteCarlo



%% Definición de parámetros y generación del canal
Iter       = 20; % Número máximo de iteraciones del algoritmo de optimización

% Parámetros del AP (Puntos de Acceso)
L          = 5;       % Número de APs en la red
Nt         = 2;       % Número de antenas en cada AP
APpwr      = 1e-3;    % Potencia máxima de transmisión de cada AP en vatios (W)

% Parámetros de los Usuarios (UE - User Equipments)
K          = 8;       % Número de UEs en la red
Nr         = 1;       % Número de antenas en cada UE
UEpwr      = 1e-4;    % Potencia máxima de transmisión de cada UE en vatios (W)

% Parámetros del RIS (Superficie Inteligente Reconfigurable)
R          = 2;       % Número de RIS en la red
M          = 64;      % Número de elementos reflectores en cada RIS

% Parámetro de ruido
sigma2     = 1e-10;   % Varianza del ruido del canal


%% Inicialización de acumuladores para las tasas de suma
sumRateLMMSE_all = zeros(Iter, N_scenarios);
sumRateRandTheta_all = zeros(Iter, N_scenarios);
sumRateNoRIS_all = zeros(Iter, N_scenarios);





for scenario=1:N_scenarios
    
    [scenario N_scenarios]
    
    filename=['Scenario3_' num2str(scenario) '.mat'];

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


    % Almacenamiento de resultados en matrices
    sumRateLMMSE_all(:, scenario) = sumRateLMMSE;
    sumRateRandTheta_all(:, scenario) = sumRateRandTheta;
    sumRateNoRIS_all(:, scenario) = sumRateNoRIS;


    % %% Graficar resultados
    % figure, hold on, grid on
    % plot(sumRateLMMSE,'-o', 'MarkerSize', 8, 'LineWidth', 1.5);   % Grafica la tasa de suma del método L-MMSE
    % plot(sumRateNoRIS,'--', 'LineWidth', 1.5);   % Grafica la tasa de suma del sistema SIN RIS
    % plot(sumRateRandTheta, '-x', 'LineWidth', 1.5); % Grafica la tasa de suma del sistema con RIS aleatorio
    % xlabel('Number of iterations');
    % ylabel('Average sum-rate (bits/s/Hz)');
    % title('Average sum-rate vs. the number of iteration');
    % legend('LMMSE', 'Random Theta', 'No RIS');

    save(fullfile('Escenarios3', filename),'sumRateLMMSE', "sumRateRandTheta","sumRateNoRIS", 'APpwr','F','Hd_lk', 'Iter', 'K','L','M','Nr','Nt','R','Theta', 'UEpwr', 'distAP2RIS','distAP2User','distRIS2User','g_lr','h_rk','sigma2','u_k');
end

%% Cálculo de promedios
avgSumRateLMMSE = mean(sumRateLMMSE_all, 2);
avgSumRateRandTheta = mean(sumRateRandTheta_all, 2);
avgSumRateNoRIS = mean(sumRateNoRIS_all, 2);

%% Graficar resultados promedio
figure, hold on, grid on
plot(avgSumRateLMMSE, '-o', 'MarkerSize', 8, 'LineWidth', 1.5); % Grafica la tasa de suma promedio del método L-MMSE
plot(avgSumRateNoRIS, '--', 'LineWidth', 1.5); % Grafica la tasa de suma promedio del sistema SIN RIS
plot(avgSumRateRandTheta, '-x', 'LineWidth', 1.5); % Grafica la tasa de suma promedio del sistema con RIS aleatorio
xlabel('Número de iteraciones');
ylabel('Tasa de suma de datos (bits/s/Hz)');
%title('Average sum-rate vs. the number of iteration');
legend('L-MMSE', 'Fase aleatoria', 'No RIS');
