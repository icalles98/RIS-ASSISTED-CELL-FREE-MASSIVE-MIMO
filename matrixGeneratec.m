function c = matrixGeneratec(L, R, K, M, Nt, u_k, Hd_lk, h_rk)
% Genera la matriz auxiliar c, utilizada en la optimización de la RIS (Theta).
%
% Parámetros de entrada:
%   L       - Número de APs (Puntos de Acceso)
%   R       - Número de RISs
%   K       - Número de UEs (Usuarios)
%   M       - Número de elementos en cada RIS
%   Nt      - Número de antenas en cada AP
%   u_k     - Vector de combinación de los UEs
%   Hd_lk   - Canal directo AP → UE
%   h_rk    - Canal RIS → UE
%
% Parámetro de salida:
%   c       - Estructura con las matrices:
%             - `c.cd_lk`: Relación entre canal directo y vector de combinación (Nt, L, K)
%             - `c.c_k`: Relación entre canal reflejado y vector de combinación (M*R, K)

%% **1️ Inicialización de las Matrices `c`**
c.cd_lk = zeros(Nt, L, K);   % Matriz de tamaño (Nt, L, K)
c.c_k = zeros(M * R, K);     % Matriz de tamaño (M*R, K)

%% **2️ Cálculo de `c.cd_lk` para el Canal Directo AP → UE**
for l = 1:L  % Para cada AP
    for k = 1:K  % Para cada usuario
        c.cd_lk(:,l,k) = Hd_lk(:,:,l,k) * u_k(:,k);
        % - `Hd_lk(:,:,l,k)`: Canal del AP `l` al usuario `k`.
        % - `u_k(:,k)`: Vector de combinación en el usuario `k`.
        % - El producto `Hd_lk * u_k` representa la señal recibida sin considerar la RIS.
    end
end

%% **3️ Cálculo de `c.c_k` para el Canal Reflejado AP → RIS → UE**
for k = 1:K  % Para cada usuario
    c.c_k(:,k) = h_rk.h_k(:,:,k) * u_k(:,k);
    % - `h_rk.h_k(:,:,k)`: Canal RIS → UE.
    % - `u_k(:,k)`: Vector de combinación en el usuario `k`.
    % - `c.c_k` modela cómo la RIS afecta la señal en cada usuario.
end

end
