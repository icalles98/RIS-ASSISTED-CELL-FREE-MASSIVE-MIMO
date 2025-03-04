function g_l = matCovertg_lr2g_l(L, R, M, Nt, g_lr)
% g_lr - Matriz de entrada con dimensiones (M, Nt, L, R)
% g_l  - Matriz de salida con dimensiones (M*R, Nt, L), combinando todas las RIS en una sola dimensión
%
% Parámetros de entrada:
%   L     - Número de APs (Puntos de Acceso)
%   R     - Número de RISs
%   M     - Número de elementos en cada RIS
%   Nt    - Número de antenas en el AP
%   g_lr  - Matriz de canal AP → RIS con dimensiones (M, Nt, L, R)
%
% Parámetro de salida:
%   g_l   - Matriz de canal AP → RIS reorganizada con tamaño (M*R, Nt, L)

% Inicialización de la matriz de salida con ceros
g_l = zeros(M * R, Nt, L);

% Reorganización de la matriz de entrada en la nueva estructura
for l = 1:L  % Para cada AP
    for r = 1:R  % Para cada RIS
        % Asigna los valores de g_lr a la nueva matriz g_l
        % Para la RIS r, sus M elementos se colocan en una sección de tamaño (M, Nt)
        g_l((r-1)*M+1:r*M, :, l) = g_lr(:,:,l,r);
    end
end
end
