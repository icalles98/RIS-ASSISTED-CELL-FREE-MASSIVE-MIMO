function h = channelGenerateh(M, Nr, distRIS2User)
% h - Matriz de canal entre la RIS y el UE
%
% Parámetros de entrada:
%   M               - Número de elementos en la RIS
%   Nr              - Número de antenas en el UE
%   distRIS2User    - Distancia entre la RIS y el UE
%
% Parámetros internos:
%   scaleRayleighB  - Escalado de la distribución Rayleigh (1 por defecto)
%   pathLossC0      - Atenuación inicial de la señal a 1 metro de distancia (1e-3)
%   kappaRIS2User   - Exponente del modelo de pérdidas de trayectoria (2.8)
%   antennaGain     - Ganancia de la antena en factor lineal (2 equivale a 3 dBi)
%
% Parámetro de salida:
%   h - Matriz de canal entre la RIS y el UE (M x Nr)

% Parámetros del modelo de canal
scaleRayleighB = 1;       % Factor de escala para la distribución Rayleigh
pathLossC0 = 1e-3;        % Atenuación inicial a 1 metro
kappaRIS2User = 2.8;      % Exponente de pérdidas de trayectoria para RIS -> UE
antennaGain = 2;          % Ganancia de antena (equivalente a 3 dBi)

% Generación del canal con distribución Rayleigh
h = raylrnd(scaleRayleighB, M, Nr);  % Matriz MxNr con amplitudes Rayleigh

% Conversión a canal complejo con fase aleatoria
h = h .* exp(1i * 2 * pi * rand(M, Nr));  

% Cálculo de la atenuación del canal basado en pérdidas de trayectoria y ganancia de antena
pathLoss = sqrt(antennaGain * pathLossC0 * distRIS2User^(-kappaRIS2User));

% Aplicación del path loss al canal
h = pathLoss * h;

end
