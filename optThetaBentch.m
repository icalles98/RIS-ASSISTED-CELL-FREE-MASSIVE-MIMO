function Theta = optThetaBentch(L, R, K, M, Nt, u_k, Hd_lk, h_rk, g_lr, F)
% Optimiza la matriz de fase de la RIS (Theta) usando programación convexa.
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
%   g_lr    - Canal AP → RIS
%   F       - Matriz de precodificación en los APs
%
% Parámetro de salida:
%   Theta   - Matriz de fase optimizada de la RIS

%% **1️ Generación de la Matriz Auxiliar `c`**
c = matrixGeneratec(L, R, K, M, Nt, u_k, Hd_lk, h_rk);
% - `c.cd_lk`: Matriz de tamaño **(Nt, L, K)**, que representa el canal descendente.
% - `c.c_k`: Matriz de tamaño **(MR, K)**, donde **MR = M*R**, combinando la contribución de la RIS.

%% **2️ Generación de la Matriz `d_lk`**
d_lk = matrixGenerated_lk(L, R, K, M, Nt, g_lr, c);
% - `d_lk`: Matriz de tamaño **(MR, Nt, L, K)**, que representa el canal reflejado.

%% **3️ Generación de la Matriz `Sigma`**
Sigma = matrixGenerateSigma(L, R, K, M, F, d_lk);
% - `Sigma`: Matriz de tamaño **(MR, MR)**, que representa la correlación entre elementos de la RIS.

%% **4 Generación de la Matriz `U`**
U = matrixGenerateU(L, R, K, M, F, c, d_lk);
% - `U`: Matriz de tamaño **(MR, 1)**, que representa la influencia de la RIS en la señal recibida.

%% **5️ Optimización de `Phi` Usando Programación Convexa**
% Se usa **CVX (Convex Optimization Toolbox)** para resolver la optimización de `Phi`, que define la fase de la RIS.

cvx_begin quiet
    % Definir la variable de optimización `Phi` como un vector complejo
    variable Phi(1, M*R) complex  

    % Función objetivo: minimizar la interferencia
    minimize (Phi * Sigma * Phi' + 2 * real(Phi * U))

    % Restricción de módulo unitario en cada elemento de `Phi`
    subject to
    for i = 1:M*R
       abs(Phi(i)) <= 1;
    end
cvx_end

%% **6 Conversión de `Phi` a la Matriz de Fase `Theta`**
Theta.Phi = Phi;  % Vector de fase (1, MR)
Theta.Theta = diag(Phi);  % Matriz diagonal de fase (MR, MR)
Theta.Theta_r = matCovertTheta2Theta_r(R, M, Theta.Theta);  % Conversión a matriz 3D (M, M, R)

end
