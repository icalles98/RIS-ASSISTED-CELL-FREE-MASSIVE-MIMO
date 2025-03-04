function [u_k, F, Theta] = initOptVariable(L, R, K, M, Nt, Nr, APpwr, UEpwr)
% Inicializa las variables de optimización en un sistema cell-free massive MIMO con RIS.
%
% Parámetros de entrada:
%   L      - Número de APs (Puntos de Acceso)
%   R      - Número de RISs
%   K      - Número de UEs (Usuarios)
%   M      - Número de elementos en cada RIS
%   Nt     - Número de antenas en cada AP
%   Nr     - Número de antenas en cada UE
%   APpwr  - Potencia máxima de transmisión del AP (en vatios)
%   UEpwr  - Potencia máxima de transmisión del UE (en vatios)
%
% Parámetros de salida:
%   u_k    - Vector de precodificación de los UEs (Nr x K)
%   F      - Matrices de precodificación en los APs (Estructura con `f_lk`, `f_k`, `F`)
%   Theta  - Matriz de configuración de la RIS (Estructura con `Theta_r`, `Theta`, `Phi`)

%% **1. Inicialización del vector de precodificación en los UEs (`u_k`)**
u_k = sqrt(UEpwr / K / Nr) * ones(Nr, K);
% - `UEpwr / K / Nr`: Se distribuye la potencia total de los UEs equitativamente entre todas sus antenas.
% - `ones(Nr, K)`: Se asigna la misma amplitud inicial a todos los UEs.

%% **2. Inicialización de la matriz de precodificación en los APs (`F`)**
F.f_lk = sqrt(APpwr / K / Nt) * ones(Nt, L, K);
% - `APpwr / K / Nt`: Se distribuye la potencia total de los APs equitativamente entre todas sus antenas y usuarios.
% - `ones(Nt, L, K)`: Se asigna un valor inicial uniforme para cada enlace AP-UE.

% Conversión de la matriz de precodificación a una forma unificada
F.f_k = matCovertflk2fk(L, K, Nt, F.f_lk);
F.F = F.f_k;  
% - `F.F` almacena la matriz de precodificación combinada de todos los APs.
% - Tamaño esperado de `F.F`: **(L*Nt, K)** (todas las antenas de los APs, combinadas en una sola dimensión).

%% **3. Inicialización de la matriz de fase de la RIS (`Theta`)**
Theta.Theta_r = zeros(M, M, R);  % Matriz de configuración de fase inicial para cada RIS

for r = 1:R
    Theta.Theta_r(:,:,r) = diag(exp(1i * 2 * pi * (rand(M,1))));  
    % - `rand(M,1)`: Genera valores aleatorios entre [0,1].
    % - `2 * pi * rand(M,1)`: Convierte estos valores a **fases aleatorias entre 0 y 2π**.
    % - `exp(1i * 2 * pi * ...)`: Genera **coeficientes de fase complejos** de magnitud unitaria.
    % - `diag(...)`: Ubica estos valores en la diagonal de una matriz **M x M**.
end

% Conversión de la matriz `Theta_r` en una representación unificada
Theta.Theta = matCovertTheta_r2Theta(R, M, Theta.Theta_r);  
% - `Theta.Theta` tiene tamaño **(MR, MR)** donde **MR = M * R**.

% Vector `Phi` para aplicar transformación a las señales de la RIS
Theta.Phi = ones(1, M*R) * Theta.Theta;  
% - `ones(1, M*R)`: Vector fila de unos de tamaño **(1, MR)**.
% - `Theta.Phi` tiene tamaño **(1, MR)** y representa la contribución total de la RIS a la señal.

end
