function [Hd_lk, h_rk, g_lr] = channelGenerate(L, R, K, M, Nt, Nr, distAP2RIS, distAP2User, distRIS2User) 
% Hd_lk - Enlace directo entre el AP y el UE
% h_rk - Enlace entre el RIS y el UE
% g_lr - Enlace entre el AP y el RIS

% Inicialización de matrices de canal:
Hd_lk = zeros(Nt, Nr, L, K); % Canal directo AP-UE
h_rk.h_rk = zeros(M, Nr, R, K); % Canal RIS-UE
g_lr.g_lr = zeros(M, Nt, L, R); % Canal AP-RIS

% Generación del canal directo Hd_lk (AP -> UE)
for l = 1:L  % Para cada AP
    for k = 1:K  % Para cada usuario (UE)
        Hd_lk(:,:,l,k) = channelGenerateHd(Nt, Nr, distAP2User(l,k));  
        % Se genera el canal directo AP-UE considerando la distancia entre ellos
    end
end

% Generación del canal h_rk (RIS -> UE)
for r = 1:R  % Para cada RIS
    for k = 1:K  % Para cada UE
        h_rk.h_rk(:,:,r,k) = channelGenerateh(M, Nr, distRIS2User(r,k));  
        % Se genera el canal RIS-UE basado en la distancia RIS-UE
    end
end

% Generación del canal g_lr (AP -> RIS)
for l = 1:L  % Para cada AP
    for r = 1:R  % Para cada RIS
        g_lr.g_lr(:,:,l,r) = channelGenerateg(M, Nt, distAP2RIS(l,r));  
        % Se genera el canal AP-RIS considerando la distancia AP-RIS
    end
end

% Conversión de las matrices de canal para su uso en la simulación
h_rk.h_k = matCoverth_rk2h_k(R, K, M, Nr, h_rk.h_rk);  % Se reestructura h_rk en una matriz de tamaño (MR, Nr, K)

g_lr.g_l = matCovertg_lr2g_l(L, R, M, Nt, g_lr.g_lr);  % Se reestructura g_lr en una matriz de tamaño (MR, Nt, L)

end
