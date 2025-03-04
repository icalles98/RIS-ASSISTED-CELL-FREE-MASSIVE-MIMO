function Lambda = matrixGenerateLambda(L, K, Nt, B)
% Genera la matriz Lambda para la optimización de la precodificación en los APs.
%
% Parámetros de entrada:
%   L       - Número de APs (Puntos de Acceso)
%   K       - Número de UEs (Usuarios)
%   Nt      - Número de antenas en cada AP
%   B       - Matriz auxiliar generada en `matrixGenerateB`
%
% Parámetro de salida:
%   Lambda  - Matriz de correlación de precodificación (L*Nt, L*Nt)

%% **1️ Inicialización de la Matriz `Lambda`**
Lambda = zeros(L * Nt, L * Nt);
% - `Lambda`: Matriz de correlación de precodificación, tamaño **(L*Nt, L*Nt)**.
% - Se inicializa en ceros.

%% **2️ Cálculo de `Lambda` Sumando la Contribución de Todos los Usuarios**
for k = 1:K  % Para cada usuario
   Lambda = Lambda + B.b_k(:,k) * B.b_k(:,k)';
   % - `B.b_k(:,k)`: Representa la influencia del canal en la señal transmitida al usuario `k`.
   % - `B.b_k(:,k) * B.b_k(:,k)'`: Producto externo para calcular la correlación.
   % - Se suman las contribuciones de todos los usuarios.
end
end
