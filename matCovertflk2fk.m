function f_k = matCovertflk2fk(L, K, Nt, f_lk)
% f_lk - Matriz de entrada con dimensiones (Nt, L, K)
% f_k  - Matriz de salida con dimensiones (L*Nt, K), combinando todas las antenas de los APs en una sola dimensión
%
% Parámetros de entrada:
%   L     - Número de APs (Puntos de Acceso)
%   K     - Número de UEs (Usuarios)
%   Nt    - Número de antenas en cada AP
%   f_lk  - Matriz de precodificación AP → UE con dimensiones (Nt, L, K)
%
% Parámetro de salida:
%   f_k   - Matriz de precodificación reorganizada con tamaño (L*Nt, K)

% Inicialización de la matriz de salida con ceros
f_k = zeros(L * Nt, K);

% Reorganización de la matriz de entrada en la nueva estructura
for k = 1:K  % Para cada usuario
   for l = 1:L  % Para cada AP
       % Asigna los valores de f_lk a la nueva matriz f_k
       % Para el AP l, sus Nt antenas se colocan en una sección de tamaño (Nt, K)
       f_k((l-1)*Nt+1:l*Nt, k) = f_lk(:, l, k);
   end
end
end
