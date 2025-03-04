function Hd = channelGenerateHd(Nt, Nr, distAP2User)
% Hd - Matriz de canal del enlace directo AP -> UE
%
% Parámetros de entrada:
%   Nt            - Número de antenas en el AP
%   Nr            - Número de antenas en el UE
%   distAP2User   - Distancia entre el AP y el UE
%
% Parámetros internos:
%   scaleRayleighB - Escalado de la distribución Rayleigh (1 por defecto)
%   pathLossC0     - Atenuación inicial de la señal a 1 metro de distancia (1e-3)
%   kappaAP2RIS    - Exponente del modelo de pérdidas de trayectoria (3.5)
%
% Parámetro de salida:
%   Hd - Matriz de canal entre el AP y el UE (Nt x Nr)

% Parámetros del modelo de canal
scaleRayleighB = 1;  % Escalado de la distribución Rayleigh
pathLossC0 = 1e-3;   % Atenuación de la señal a 1 metro de distancia
kappaAP2RIS = 3.5;   % Exponente de la ley de pérdidas de trayectoria

% Generación del canal con distribución de Rayleigh (modelo de desvanecimiento)
Hd = raylrnd(scaleRayleighB, Nt, Nr);  % Distribución Rayleigh estándar

% Aplicación de fase aleatoria para convertirlo en un canal de Rayleigh complejo
Hd = Hd .* exp(1i * 2 * pi * rand(Nt, Nr)); 

% Cálculo de la atenuación del canal basado en pérdidas de trayectoria
pathLoss = sqrt(pathLossC0 * distAP2User^(-kappaAP2RIS));

% Aplicación del path loss a la matriz de canal
Hd = pathLoss * Hd;

end
