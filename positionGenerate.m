function [distAP2RIS, distAP2User, distRIS2User] = positionGenerate(L, K, R) 
% Función para generar las posiciones de los Puntos de Acceso (AP), 
% Superficies Inteligentes Reconfigurables (RIS) y Usuarios (UE).
% También calcula las distancias entre AP-RIS, AP-UE y RIS-UE.

DIST = 80; % Distancia central para la generación de usuarios (en metros)
distAPHeight = 3; % Altura de los APs (en metros)
distRISHeight = 6; % Altura de los RIS (en metros)
distUserHeight = 1.5; % Altura de los UEs (en metros)
positionUserR = 1; % Radio de dispersión para la generación de UEs

% Inicialización de matrices de distancias
distAP2RIS = zeros(L,R);  % Matriz de distancia AP-RIS
distAP2User = zeros(L,K); % Matriz de distancia AP-UE
distRIS2User = zeros(R,K); % Matriz de distancia RIS-UE

% Inicialización de matrices de posiciones
positionAP = zeros(L,2);  % Posiciones de los APs (coordenadas X, Y)
positionRIS = zeros(R,2); % Posiciones de los RIS (coordenadas X, Y)
positionUser = zeros(K,2); % Posiciones de los UEs (coordenadas X, Y)

%% Generación de posiciones

% Generación de posiciones de los APs
for l = 1:L
    positionAP(l,:) = [(l-1)*40 -50]; % Los APs están espaciados 40 metros entre sí y ubicados en Y=-50
end

% Generación de posiciones de los RIS
positionRIS(1,:) = [60 10];  % Primer RIS en coordenadas (60,10)
positionRIS(2,:) = [100 10]; % Segundo RIS en coordenadas (100,10)


% **Distribución Uniforme de UEs en un Área Cuadrada**
X_RANGE = [40, 120];  % Rango de posiciones en X para los UEs (mínimo, máximo)
Y_RANGE = [-10, 20];    % Rango de posiciones en Y para los UEs (mínimo, máximo)

% Generar posiciones de UEs uniformemente distribuidos dentro del área
positionUser(:,1) = X_RANGE(1) + (X_RANGE(2) - X_RANGE(1)) * rand(K,1); % X aleatorio dentro del rango
positionUser(:,2) = Y_RANGE(1) + (Y_RANGE(2) - Y_RANGE(1)) * rand(K,1); % Y aleatorio dentro del rango

%% Cálculo de las distancias

% Cálculo de la distancia entre los APs y los RIS
for l = 1:L
    for r = 1:R
        distAP2RIS(l,r) = sqrt(sum((positionAP(l,:) - positionRIS(r,:)).^2) + (distAPHeight - distRISHeight)^2);
        % Distancia euclidiana en 3D considerando la diferencia de altura
    end
end

% Cálculo de la distancia entre los APs y los UEs
for l = 1:L
    for k = 1:K
        distAP2User(l,k) = sqrt(sum((positionAP(l,:) - positionUser(k,:)).^2) + (distAPHeight - distUserHeight)^2);
        % Distancia euclidiana en 3D considerando la diferencia de altura
    end
end

% Cálculo de la distancia entre los RIS y los UEs
for r = 1:R
    for k = 1:K
        distRIS2User(r,k) = sqrt(sum((positionRIS(r,:) - positionUser(k,:)).^2) + (distRISHeight - distUserHeight)^2);
        % Distancia euclidiana en 3D considerando la diferencia de altura
    end
end

%% **Graficar el escenario**
figure;
hold on; grid on; axis equal;

% Dibujar los APs como cruces negras
scatter(positionAP(:,1), positionAP(:,2), 120, 'kx', 'LineWidth', 2, 'DisplayName', 'APs');

% Dibujar los RIS como cuadrados rojos
scatter(positionRIS(:,1), positionRIS(:,2), 100, 'rs', 'LineWidth', 2, 'DisplayName', 'RIS');

% Dibujar los UEs como círculos azules
scatter(positionUser(:,1), positionUser(:,2), 70, 'bo', 'MarkerFaceColor', 'b', 'DisplayName', 'UEs');

% **Opcional: Dibujar líneas para visualizar conexiones**
for l = 1:L
    for r = 1:R
        plot([positionAP(l,1), positionRIS(r,1)], [positionAP(l,2), positionRIS(r,2)], 'k--'); % AP-RIS
    end
end

for r = 1:R
    for k = 1:K
        plot([positionRIS(r,1), positionUser(k,1)], [positionRIS(r,2), positionUser(k,2)], 'r-.'); % RIS-UE
    end
end

for l = 1:L
    for k = 1:K
        plot([positionAP(l,1), positionUser(k,1)], [positionAP(l,2), positionUser(k,2)], 'b:'); % AP-UE
    end
end

% Etiquetas y leyenda
legend('AP', 'RIS', 'UE');
xlabel('Position X (meters)');
ylabel('Position Y (meters)');
title('Deployment of APs, RISs and UEs');
end


