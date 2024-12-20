function [kk,ff]=assemb(kk,ff,k,f,index)
% Assembla a matriz de rigidez global e vector de forcas global
% kk - matriz de rigidez global
% ff - vector de forcas global
% k - matriz de rigidez do elemento
% f - vector de forcas do elemento
% index - lista dos gdl do elemento
ff(index)=ff(index)+f;
kk(index,index)=kk(index,index)+k;