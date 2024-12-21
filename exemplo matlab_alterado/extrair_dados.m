function [gcoord, nodes] = extrair_dados()
    % Abrir os ficheiros para leitura
    fileID0 = fopen('nodes_simples.txt','r');
    fileID1 = fopen('elements_simples.txt','r');
    
    %Ler o ficheiro dos nos
    
    linhas_validas_nos = {};
    
    % Ler o ficheiro dos nos linha a linha
    while ~feof(fileID0)
    
        linha_nos = strtrim(fgetl(fileID0)); % Lê linhas mas tira as que têm espaços 
        
        % Verificar se a linha é válida (não está em branco e não contém palavras-chave)
        if ~isempty(linha_nos) && ~contains(linha_nos, {'NODE', 'X', 'Y', 'Z'})
            linhas_validas_nos{end+1} = linha_nos; % Adicionar linha válida ao array
        end
    
    end
    
    fclose(fileID0);
    % Ler o ficheiro dos elementos
    
    linhas_validas_elementos = {};
    
    % Ler o ficheiro dos elementos linha a linha
    while ~feof(fileID1)
    
        linha_elementos = strtrim(fgetl(fileID1)); % Ler uma linha
        
        % Verificar se a linha é válida (não está em branco e não contém palavras-chave)
        if ~isempty(linha_elementos) && ~contains(linha_elementos, {'ELEM', 'MAT', 'TYP', 'REL', 'ESY', 'SEC', 'NODES'})
            linhas_validas_elementos{end+1} = linha_elementos; % Adicionar linha válida ao array
        end
    
    end
    
    fclose(fileID1);
    % Separar dados das coordenadas dos nós por colunas
    % Converter as linhas válidas em dados numéricos
    dados_nos = cellfun(@str2num, linhas_validas_nos, 'UniformOutput', false); 
    dados_nos = vertcat(dados_nos{:}); % Converter para uma matriz numérica
    
    coordx_nos=[];
    coordy_nos=[];
    Coordenadas_nos=[];
    
    for i = 1:1:length(dados_nos)
        coordx_nos=[coordx_nos;dados_nos(i,2)];
        coordy_nos=[coordy_nos;dados_nos(i,3)];
        Coordenadas_nos=[Coordenadas_nos;i,coordx_nos(i),coordy_nos(i)];
    end
    % Separar dados das conectividades dos elementos por colunas
    % Converter as linhas válidas em dados numéricos
    dados_elementos = cellfun(@str2num, linhas_validas_elementos, 'UniformOutput', false); 
    dados_elementos = vertcat(dados_elementos{:}); % Converter para uma matriz numérica
    
    conectividades_1=[];
    conectividades_2=[];
    conectividades_3=[];
    conectividades_4=[];
    conectividades_5=[];
    conectividades_6=[];
    Coordenadas_elementos=[];
    
    for i = 1:1:length(dados_elementos)
        conectividades_1=[conectividades_1;dados_elementos(i,7)];
        conectividades_2=[conectividades_2;dados_elementos(i,8)];
        conectividades_3=[conectividades_3;dados_elementos(i,9)];
        conectividades_4=[conectividades_4;dados_elementos(i,11)];
        conectividades_5=[conectividades_5;dados_elementos(i,12)];
        conectividades_6=[conectividades_6;dados_elementos(i,14)];
        Coordenadas_elementos=[Coordenadas_elementos;i,conectividades_1(i),conectividades_2(i),conectividades_3(i),conectividades_4(i),conectividades_5(i),conectividades_6(i)];
    end
    
    % Passar para gcoord e nodes 
    
    gcoord = Coordenadas_nos(:, 2:end);
    nodes = Coordenadas_elementos(:, 2:end);
end