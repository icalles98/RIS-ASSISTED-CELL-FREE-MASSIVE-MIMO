function Theta = matCovertTheta_r2Theta(R, M, Theta_r)
% Theta_r - Matriz de entrada con dimensiones (M, M, R)
% Theta   - Matriz de salida con dimensiones (M*R, M*R), combinando todas las RIS en una sola matriz
%
% Parámetros de entrada:
%   R       - Número de RISs
%   M       - Número de elementos en cada RIS
%   Theta_r - Matriz de fase de cada RIS con dimensiones (M, M, R)
%
% Parámetro de salida:
%   Theta   - Matriz de fase global de la RIS con dimensiones (M*R, M*R)

% Inicialización de la matriz de salida con ceros
Theta = zeros(M * R, M * R);

% Construcción de la matriz diagonal por bloques
for r = 1:R  % Para cada RIS
    % Copia Theta_r(:,:,r) en la diagonal de Theta
    Theta((r-1)*M+1:r*M, (r-1)*M+1:r*M) = Theta_r(:,:,r);  
end
end
