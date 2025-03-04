function H_lk = channelGenerateDL(L, K, Nt, Nr, Hd_lk, h_rk, g_lr, Theta)
% Genera el canal de enlace descendente en un sistema cell-free MIMO con RIS.
%
% Parámetros de entrada:
%   L       - Número de APs (Puntos de Acceso)
%   K       - Número de UEs (Usuarios)
%   Nt      - Número de antenas en cada AP
%   Nr      - Número de antenas en cada UE
%   Hd_lk   - Canal directo AP → UE
%   h_rk    - Canal RIS → UE
%   g_lr    - Canal AP → RIS
%   Theta   - Matriz de fase de la RIS
%
% Parámetro de salida:
%   H_lk    - Estructura con los canales de enlace descendente:
%             - `H_lk.H_lk`: Canal combinado AP → UE (directo + reflejado) con tamaño (Nt, Nr, L, K).
%             - `H_lk.H_k`: Canal combinado en formato consolidado con tamaño (L*Nt, K).

%% **1 Inicialización de la Matriz de Canal**
H_lk.H_lk = zeros(Nt, Nr, L, K);

%% **2️ Cálculo del Canal Descendente Considerando el Efecto de la RIS**
for l = 1:L  % Para cada AP
    for k = 1:K  % Para cada usuario
        % Canal descendente: Directo + Reflejado a través de la RIS
        H_lk.H_lk(:,:,l,k) = (Hd_lk(:,:,l,k)' + h_rk.h_k(:,:,k)' * Theta.Theta * g_lr.g_l(:,:,l))';
        % - `Hd_lk(:,:,l,k)`: Canal directo entre el AP `l` y el usuario `k`.
        % - `g_lr.g_l(:,:,l)`: Canal entre el AP `l` y la RIS.
        % - `Theta.Theta`: Matriz de fase de la RIS, que modula la señal reflejada.
        % - `h_rk.h_k(:,:,k)`: Canal entre la RIS y el usuario `k`.
        % - `(Hd_lk' + h_rk' * Theta * g_lr)'`: Se toma la transpuesta debido a la convención de dimensiones.
    end
end

%% **3️ Conversión de `H_lk` a una Representación Unificada**
H_lk.H_k = matCovertH_lk2H_k(L, K, Nt, Nr, H_lk.H_lk);
% - `matCovertH_lk2H_k(...)` reorganiza `H_lk` en una única matriz consolidada.
% - `H_k` tiene tamaño **(L*Nt, K)**.
end
