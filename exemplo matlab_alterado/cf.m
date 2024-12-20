function [kk,ff]=cf(kk,ff,bcdof,bcval)
% Aplica condicoes de fronteira no sistema [kk]{u}={ff}
% kk - matriz de rigidez global
% ff - vector de forcas global
% bcdof - vector dos gdl restringidos
% bcval - vector com o respectivo valor da restricao
kk(bcdof,:)=zeros(size(bcdof,2),size(kk,2)); % por linha a zeros
kk(:,bcdof)=zeros(size(kk,1),size(bcdof,2)); % por coluna a zeros
kk(bcdof,bcdof)=eye(size(bcdof,2),size(bcdof,2)); % uns na diagonal
ff=ff-kk(:,bcdof)*bcval'; % passagem das colunas da matriz de rigidez para o vetor de forças
ff(bcdof)=bcval'; % imposição dos valores restringidos