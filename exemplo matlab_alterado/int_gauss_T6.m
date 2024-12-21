%% Isto não é para mudar, são valores tabelados, para o nosso caso T6 
%% ordem 2 bastaria porque o nosso polinomio é de grau 2 mas o stiff pede
%% ordem maior (3)


function [ksi, pesos, eta] = int_gauss_T6(ordem)
% Pontos de Gauss (GenipT do stor)
        switch ordem
            case 1 
                ksi = [1/3];
                eta = [1/3];
                pesos = [1];
    
            case 2 
                ksi = [1/6, 2/3, 1/6];
                eta = [1/6, 1/6, 2/3];
                pesos = [1/3, 1/3, 1/3];
    
            case 3 
                ksi = [1/3, 0.6, 0.2, 0.2];
                eta = [1/3, 0.2, 0.6, 0.2];
                pesos = [-27/48, 25/48, 25/48, 25/48];
    
            case 4 
                ksi = [0.445948, 0.445948, 0.108103, 0.108103, 0.816847, 0.091576];
                eta = [0.108103, 0.445948, 0.445948, 0.816847, 0.091576, 0.445948];
                pesos = [0.223381, 0.223381, 0.109951, 0.109951, 0.109951, 0.109951];
    
            case 5 
                ksi = [1/3, 0.059715, 0.470142, 0.470142, 0.797426, 0.101286, 0.101286];
                eta = [1/3, 0.470142, 0.059715, 0.470142, 0.101286, 0.797426, 0.101286];
                pesos = [9/40, 0.132394, 0.132394, 0.132394, 0.125939, 0.125939, 0.125939];
    
            otherwise
                error('Não existe');
        end
    end