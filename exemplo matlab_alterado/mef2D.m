%% VOU ALTERAR ESTA MERDA PARA O MEU
% Programa de elementos finitos para elementos 2D
% Exemplo para o elemento T6 em elasticidade 2D

clear all
close all

nnel=6; % numero de nos por elemento
ndof=2; %numero de graus de liberdade por no (para problemas de elasticidade 2D)
nnode=2620; % numero de nos
nelem=1250; % numero de elementos
sdof=ndof*nnode; % numero total de graus de liberdade na malha

[gcoord, nodes] = extrair_dados(); % Extrair dados de nos e elementos


% numeração dos graus de liberdade globais dos nós globais
igdl=0;
for i=1:nnode
    for j=1:ndof
        igdl=igdl+1;
        gdl(i,j)=igdl;
    end
end


% propriedades dos elementos
for iel=1:nelem
    Young(iel)=200e9; % especifica modulo de elasticidade igual para todos os elementso
    nu(iel)=0.3;
    tk(iel)=1e-3; % espessura
end

%% Aplicar carga pontual a todos os nos
face_force = find(gcoord(:, 1) == 0.8); % Ir buscar nos que estão na zona 
% da direita da placa para aplicarmos a força

% Carregamento pontual nos nos
P(1:sdof)=0;
P(face_force*2-1)=1e6; % Aplicar força ao grau de liberdade em x dos nos do
% face_force
 P=P'; % transposicao para vector coluna

%% Aplicar condições de fronteira
% Ir buscar nos que estão em x = 0 e y = 0
nos_x_nulo = find(gcoord(:, 1) == 0);
nos_y_nulo = find(gcoord(:, 2) == 0);

nos_x_nulo = nos_x_nulo'; 
nos_y_nulo = nos_y_nulo'; 

% Ir buscar os gdl correspondentes aos nos 
gdl_nulo_x = nos_x_nulo*2-1;
gdl_nulo_y = nos_y_nulo*2;
fronteiras = [gdl_nulo_x, gdl_nulo_y];
n_fronteiras = size(fronteiras,2);

% Condicoes de fronteira de deslocamento
 % bcdof(1)=1; % graus de liberdade com restricao aplicada
 % bcval(1)=0; % valor da restricao aplicada
% bcdof=[1 11 12 21];
% bcval=[0 0 0 0];
 bcdof= fronteiras;
 bcval=zeros(1, n_fronteiras);
%% Acho que isto já tá cremoso
% inicializacao a zeros das matrizes e vectores
ff=zeros(sdof,1); % vector de forças global
kk=zeros(sdof,sdof); % matriz de rigidez global
index=zeros(nnel*ndof,1); % vector de indexacao dos graus de liberdade do elemento (para assemblegem)

% calculo das matrizes de rigidez e vectores de forcas dos elementos e respectiva assemblagem
for iel=1:nelem
  n=nodes(iel,1:nnel); % extraccao da numeracao global de nos para cada elemento
  xe=gcoord(n,1); % extraccao das coordenadas de cada no do elemento
  ye=gcoord(n,2);
  k=stif_T6(Young(iel),nu(iel),tk(iel),xe,ye); % cálculo da matriz de rigidez do elemento
  f=zeros(nnel*2,1); % as forças distribuidas vão ser aplicadas nos nós (forças equivalentes nodais)
  index=eldof(iel,nnel,nodes,gdl);
  [kk,ff]=assemb(kk,ff,k,f,index);
end

%% Parece me safe
% imposicao de condicoes de fronteira
[kk,ff]=cf(kk,ff,bcdof,bcval); % O professor atualizou isto

% imposicao de cargas pontuais
ff=ff+P;

% solucao do sistema de equacoes
u=kk\ff;

%% In review
% representação da deformada
UX = u(1:2:2*nnode);
UY = u(2:2:2*nnode);
scaleFactor = 100;
figure
drawingField(gcoord+scaleFactor*[UX UY],nodes,'T6',UX);%U XX
hold on
drawingMesh(gcoord+scaleFactor*[UX UY],nodes,'T6','-');
drawingMesh(gcoord,nodes,'T6','--');
colorbar
title('Displacement field u_x (on deformed shape)')
%% 
% % cálculo das tensões (componentes no plano)
% stress=zeros(nelem,4,3); % 3 in-plane componentes of stress per element, at the 4 Gauss points
% for iel=1:nelem
%    n=nodes(iel,1:nnel); % extraccao da numeracao global de nos para cada elemento
%    xe=gcoord(n,1); % extraccao das coordenadas de cada no do elemento
%    ye=gcoord(n,2);
%    index=eldof(iel,nnel,nodes,gdl);
%    ue=u(index); % deslocamentos do elemento
%    stress(iel,:,:)=stress_Q9(Young(iel),nu(iel),tk(iel),xe,ye,ue); % tensões no plano
%   % Extrapolation of the stress from Gauss points to Q9 nodes
%    T=[ 1+0.5*sqrt(3), -0.5, 1-0.5*sqrt(3), -0.5;...
%        -0.5, 1+0.5*sqrt(3), -0.5, 1-0.5*sqrt(3);...
%        1-0.5*sqrt(3), -0.5, 1+0.5*sqrt(3), -0.5;...
%        -0.5, 1-0.5*sqrt(3), -0.5, 1+0.5*sqrt(3);...
%        (1+sqrt(3))/4, (1+sqrt(3))/4, (1-sqrt(3))/4, (1-sqrt(3))/4;...
%        (1-sqrt(3))/4, (1+sqrt(3))/4, (1+sqrt(3))/4, (1-sqrt(3))/4;...
%        (1-sqrt(3))/4, (1-sqrt(3))/4, (1+sqrt(3))/4, (1+sqrt(3))/4;...
%        (1+sqrt(3))/4, (1-sqrt(3))/4, (1-sqrt(3))/4, (1+sqrt(3))/4;...
%        0.25, 0.25, 0.25, 0.25];
%    stress_nodes(iel,1:9,1)=T*stress(iel,1:4,1)';
%    stress_nodes(iel,1:9,2)=T*stress(iel,1:4,2)';
%    stress_nodes(iel,1:9,3)=T*stress(iel,1:4,3)';
% end
% 
% % stress averaging at nodes
%  stressAvg = zeros(nnode,3);
%  for i = 1:3
%      currentStress = stress_nodes(:,:,i);
%      for n = 1:nnode
%          idx = find(n==nodes);
%          stressAvg(n,i) = sum(currentStress(idx))/length(currentStress(idx));
%      end
%  end
% 
%  % surface representation
%  figure; hold on
%  for k = 1:size(nodes,1)
%      patch(gcoord(nodes(k,1:4),1), gcoord(nodes(k,1:4),2),...
%      gcoord(nodes(k,1:4),1)*0, stressAvg(nodes(k,1:4),2))
%  end
%  axis equal; axis off
%  colorbar
%  title('Averaged nodal stress field \sigma_{xx}')

