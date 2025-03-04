function d_lk = matrixGenerated_lk(L, R, K, M, Nt, g_lr, c)
% Genera la matriz auxiliar d_lk, utilizada en la optimización de la RIS (Theta).
%
% Parámetros de entrada:
%   L       - Número de APs (Puntos de Acceso)
%   R       - Número de RISs
%   K       - Número de UEs (Usuarios)
%   M       - Número de elementos en cada RIS
%   Nt      - Número de antenas en cada AP
%   g_lr    - Canal entre AP y RIS
%   c       - Matriz auxiliar generada en `matrixGeneratec`
%
% Parámetro de salida:
%   d_lk    - Matriz auxiliar que representa el canal reflejado modificado por la RIS (M*R, Nt, L, K)

%% **1️ Inicialización de `d_lk`**
d_lk = zeros(M * R, Nt, L, K);
% - `d_lk(:,:,l,k)`: Modela la señal reflejada en el usuario `k` desde el AP `l`, considerando la RIS.
% - **Dimensiones:** `(M*R, Nt, L, K)`, donde:
%   - `M*R`: Total de elementos activos en la RIS.
%   - `Nt`: Antenas en cada AP.
%   - `L`: Número de APs.
%   - `K`: Número de usuarios.

%% **2️ Cálculo de `d_lk`**
for l = 1:L  % Para cada AP
    for k = 1:K  % Para cada usuario
        d_lk(:,:,l,k) = diag(c.c_k(:,k)') * g_lr.g_l(:,:,l);
        % - `diag(c.c_k(:,k)')`: Matriz diagonal con la señal procesada en la RIS para el usuario `k`.
        % - `g_lr.g_l(:,:,l)`: Canal entre el AP `l` y la RIS.
        % - La multiplicación `diag(c.c_k(:,k)') * g_lr.g_l(:,:,l)` representa la señal modulada por la RIS antes de llegar al usuario.
    end
end

end
