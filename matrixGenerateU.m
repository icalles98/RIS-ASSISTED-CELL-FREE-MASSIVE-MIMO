function U = matrixGenerateU(L, R, K, M, F, c, d_lk)
% Genera la matriz U, utilizada en la optimización de la RIS (Theta).
%
% Parámetros de entrada:
%   L       - Número de APs (Puntos de Acceso)
%   R       - Número de RISs
%   K       - Número de UEs (Usuarios)
%   M       - Número de elementos en cada RIS
%   F       - Matriz de precodificación en los APs
%   c       - Matriz auxiliar generada en `matrixGeneratec`
%   d_lk    - Matriz auxiliar que representa el canal reflejado modificado por la RIS
%
% Parámetro de salida:
%   U       - Matriz que modela la influencia de la RIS en la propagación de la señal (M*R,1)

%% **1️ Inicialización de Variables Temporales**
uTemp1 = zeros(M * R, 1);       % - `uTemp1`: Acumula la interferencia indirecta a través de la RIS.
uTemp2 = zeros(M * R, 1);       % - `uTemp2`: Acumula la interferencia directa desde la RIS.
sumTemp1 = zeros(M * R, 1);     % - `sumTemp1`: Acumula el impacto de la RIS en cada iteración.
sumTemp2 = 0;                   % - `sumTemp2`: Acumula la interferencia combinada AP-RIS.


%% **2️ Cálculo del Primer Término `uTemp1`**
for k = 1:K  % Para cada usuario
    for i = 1:K  % Para cada usuario interferente
        for l = 1:L  % Para cada AP
            sumTemp1 = sumTemp1 + d_lk(:,:,l,k) * F.f_lk(:,l,k);
            sumTemp2 = sumTemp2 + c.cd_lk(:,l,k)' * F.f_lk(:,l,k);
        end
        uTemp1 = uTemp1 + sumTemp1 * sumTemp2';
        sumTemp1 = zeros(M * R, 1);  % Reiniciar `sumTemp1`
        sumTemp2 = 0;  % Reiniciar `sumTemp2`
    end
end
% - `sumTemp1`: Modela la señal reflejada por la RIS desde el AP `l` hasta el usuario `k`.
% - `sumTemp2`: Modela la interferencia directa desde el AP `l` hasta el usuario `k`.
% - `uTemp1`: Representa el impacto combinado de la RIS en la señal transmitida.

%% **3️ Cálculo del Segundo Término `uTemp2`**
for k = 1:K  % Para cada usuario
    for l = 1:L  % Para cada AP
        uTemp2 = uTemp2 + d_lk(:,:,l,k) * F.f_lk(:,l,k);
    end
end
% - `uTemp2`: Modela la interferencia directa desde la RIS a los usuarios.

%% **4️ Cálculo Final de `U`**
U = uTemp1 - uTemp2;
% - `U`: Representa la influencia de la RIS en la propagación de la señal, usada en la optimización de `Theta`.

end
