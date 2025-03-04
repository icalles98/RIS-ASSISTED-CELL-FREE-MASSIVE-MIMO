function H_k = matCovertH_lk2H_k(L, K, Nt, Nr, H_lk)
% Conversión de la matriz de canal H_lk a H_k en un sistema cell-free MIMO masivo.
% Esta función reorganiza los coeficientes del canal para facilitar su uso en otras optimizaciones.

% 1️ Definición de la matriz de salida H_k
% Se inicializa H_k con dimensiones adecuadas para almacenar los coeficientes de canal reorganizados.
H_k = zeros(L*Nt, Nr, K);
% - L: Número de APs.
% - K: Número de usuarios (UEs).
% - Nt: Número de antenas por AP.
% - Nr: Número de antenas por usuario.
% - H_lk: Matriz de canal en la forma (Nt, Nr, L, K).

% 2️ Conversión de la estructura del canal
for l = 1:L   % Para cada AP
    for k = 1:K  % Para cada usuario
        % Se reorganizan los coeficientes del canal en una nueva estructura.
        H_k((l-1)*Nt+1:l*Nt,:,k) = H_lk(:,:,l,k);
    end
end
end
