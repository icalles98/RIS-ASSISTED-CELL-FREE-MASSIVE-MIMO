function g = channelGenerateg(M, Nt, distAP2RIS) 
% g - Matriz de canal entre el AP y la RIS
%
% Parámetros de entrada:
%   M             - Número de elementos en la RIS
%   Nt            - Número de antenas en el AP
%   distAP2RIS    - Distancia entre el AP y la RIS
%
% Parámetros internos:
%   pathLossC0    - Atenuación inicial de la señal a 1 metro de distancia (1e-3)
%   kappaAP2RIS   - Exponente del modelo de pérdidas de trayectoria (2.2)
%   antennaGain   - Ganancia de la antena en factor lineal (2 equivale a 3 dBi)
%
% Parámetro de salida:
%   g - Matriz de canal entre el AP y la RIS (M x Nt)

% Parámetros del modelo de canal
pathLossC0 = 1e-3;       % Atenuación de referencia a 1 metro de distancia
kappaAP2RIS = 2.2;       % Exponente de pérdidas de trayectoria para AP -> RIS
antennaGain = 2;         % Ganancia de antena (equivalente a 3 dBi)

% Inicialización de la matriz de canal con unos
g = ones(M, Nt);         % Matriz de canal inicial de tamaño (M x Nt)

% Cálculo de la atenuación del canal basado en pérdidas de trayectoria y ganancia de antena
pathLoss = sqrt(antennaGain * pathLossC0 * distAP2RIS^(-kappaAP2RIS));

% Aplicación del path loss al canal
g = pathLoss * g;

end
