%% Isto não é para mudar, são valores tabelados, para o nosso caso T6 
%% ordem 2 bastaria porque o nosso polinomio é de grau 2 mas o stiff pede
%% ordem maior (3)
function [ksi,pesos]=int_gauss(ordem)
%
% 
%
switch ordem
case 1
    ksi(1)=0.0;
    pesos(1)=2.0;
case 2
    ksi(1)=-0.5773502692;
    ksi(2)= 0.5773502692;
    pesos(1)=1;
    pesos(2)=1;
case 3
    ksi(1)=-0.774596697;
    ksi(2)= 0.0;
    ksi(3)= 0.774596697;
    pesos(1)= 0.5555555556;
    pesos(2)= 0.8888888889;
    pesos(3)= 0.5555555556;
end

    