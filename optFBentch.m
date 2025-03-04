function F = optFBentch(L, K, Nt, APpwr, H_lk, u_k) 
% Función para la optimización de la precodificación en un sistema cell-free MIMO masivo sin RIS.
% Se utiliza optimización convexa (CVX) para minimizar la interferencia y mejorar la transmisión.

% 1️ Matriz de restricción de potencia para cada AP
% Esta matriz se usa en las expresiones de CVX para garantizar que la potencia total de cada AP no exceda su límite.
P_l = zeros(Nt, L*Nt, L);
for l = 1:L
    P_l(:,(l-1)*Nt+1:l*Nt,l) = eye(Nt);
end

% 2️ Generación de la matriz auxiliar B
% B almacena la información del canal y la combinación de los UEs.
B = matrixGenerateB(L, K, Nt, H_lk, u_k); 
% Tamaño de las matrices generadas:
% B.b_lk:(Nt,L,K) - Matriz que almacena las relaciones entre APs y UEs.
% B.b_k:(L*Nt,K) - Matriz con los vectores de combinación.
% B.B:(L*Nt,K) - Matriz usada en la optimización de F.

% 3️ Generación de la matriz auxiliar Lambda
% Lambda representa una métrica de interferencia basada en B.
Lambda = matrixGenerateLambda(L, K, Nt, B); % Tamaño - (L*Nt,L*Nt)

% 4️ Optimización de la precodificación F utilizando CVX
cvx_begin quiet
variable F_CVX(L*Nt,K) complex % Definición de la variable F como matriz compleja
minimize (square_pos(norm(B.B'*F_CVX, 'fro'))- 2*trace(real(B.B'*F_CVX)))
% La minimización busca reducir la interferencia y mejorar la relación señal-interferencia.

% Restricción de potencia en los APs
subject to
for l = 1:L
   norm(P_l(:,:,l)*F_CVX,'fro') <= sqrt(APpwr);
end
cvx_end

% 5️ Conversión y almacenamiento de la matriz de precodificación optimizada F
F.F = F_CVX;
F.f_k = F_CVX;
F.f_lk = matCovertf_k2f_lk(L, K, Nt, F.f_k); % Conversión para cada AP
end
