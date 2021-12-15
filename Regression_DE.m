% Non linear regression  With Differencial Evolution
% Using data of the exponential phase of the growth of covid in Mexico 2020
% (first 36 days)


clc;
clear all;
close all;


% Data
Data = 'Data.txt';
%Convert the data in a matrix 36X2
[datos,delimiterOut]=importdata(Data);
%Calculating the amount of the data
[puntos,~] = size(datos);

% introducing noise to the data
% [-noiScale,noiScale]
noiScale = 40;
r_i = -noiScale + ((noiScale - (-noiScale)).* rand(puntos,1));
datos(:,2) = datos(:,2) + r_i;

% Y dessire values
Y_esperado = datos(:,2);

%aproximating an exponential function
g = @(w1,w2) w1.*exp(w2.* datos(:,1));
%Calculamos la funcion del error que queremos ptimizar
f = @(w1,w2) (1/(2*puntos))*sum((Y_esperado - (g(w1,w2))).^2);

%upper limit
U = [1 1];
%Lower limit
L = [0 0];

% Variables in the problem
D = 2;
%Population
poblacion = 100;
%Iterations
G = 100;

% Amplification Factor
F = .15;
% Combination factor
Cr = 0.8;


% INICIALIZATION
ind = zeros(D, poblacion);
for i=1:poblacion
    r = rand(2);
    ind(:,i) = L + (U - L) * r;
end

%Graphicating data
grid on
plot(datos(:,1),datos(:,2), 'r*');



for k=1:G
    
    
    for i=1: poblacion
        %mutation vector
        r = randperm(poblacion);
        r = r(r~=i);

        v = ind(:,r(1)) + F*(ind(:,r(2)) - ind(:,r(3)));
        
        %proof vector
        u = ind(:,i);

        for j=1: D
            %combining mutation vector en proof vector
            if rand < Cr
                u(j) = v(j);
            end
        end
        
        %if the prooof vector is doing better we switch the solutions
        if f(ind(1,i),ind(2,i)) > f(u(1),u(2))
            ind(:,i) = u;
        end
    end

end


values =zeros(1,poblacion);

%Choosing better solution
for i=1:poblacion
    values(i) = f(ind(1,i),ind(2,i));

end
[~,n] = min(values);
best = ind(:,n)


hold on
plot(datos(:,1),g(best(1),best(2)), 'b-')

