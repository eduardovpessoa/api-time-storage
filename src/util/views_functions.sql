-- VIEW DOS DADOS DO DASHBOARD
CREATE OR REPLACE VIEW v_dashboard AS
 SELECT count(documento.id_documento) AS documentos,
    ( SELECT count(autor.id_autor) AS count
           FROM autor) AS autores,
    ( SELECT count(usuario.id_usuario) AS count
           FROM usuario) AS usuarios,
    ( SELECT count(genero.id_genero) AS count
           FROM genero) AS generos
   FROM documento;

-- VIEW DOS DOCUMENTOS
CREATE OR REPLACE VIEW v_docs AS
 SELECT d.id_documento,
    d.titulo_documento,
    to_char(d.data_publicacao_documento::timestamp with time zone, 'YYYY-mm-dd'::text) AS data_publicacao_documento,
    a.nome_autor,
    c.descricao_categoria,
    e.descricao_editora,
    ( SELECT min(imagem.caminho_imagem::text) AS min
           FROM imagem
          WHERE imagem.id_documento = d.id_documento) AS caminho_imagem
   FROM documento d
     JOIN autor_documento ad ON d.id_documento = ad.id_documento
     JOIN autor a ON ad.id_autor = a.id_autor
     JOIN categoria c ON d.id_categoria = c.id_categoria
     JOIN editora e ON d.id_editora = e.id_editora
  WHERE d.status_documento = 0
  ORDER BY d.titulo_documento;
  
-- VIEW DO DOCUMENTO DETALHADO (PS: FILTRAR POR ID DO DOC.)
CREATE OR REPLACE VIEW v_docs AS
   SELECT d.id_documento,
    d.titulo_documento,
    d.sinopse_documento,
    to_char(d.data_publicacao_documento::timestamp with time zone, 'YYYY-mm-dd'::text) AS data_publicacao_documento,
    d.status_documento,
    to_char(d.data_publicacao_documento::timestamp with time zone, 'YYYY-mm-dd'::text) AS data_inclusao_documento,
    d.id_usuario,
    a.nome_autor,
    c.descricao_categoria,
    e.descricao_editora
   FROM documento d
     JOIN autor_documento ad ON d.id_documento = ad.id_documento
     JOIN autor a ON ad.id_autor = a.id_autor
     JOIN categoria c ON d.id_categoria = c.id_categoria
     JOIN editora e ON d.id_editora = e.id_editora
 LIMIT 1;
 
 -- VIEW PARA RETORNAR OS DADOS DO USUÁRIO APÓS O LOGIN
 CREATE OR REPLACE v_login AS
  SELECT p.id_pessoa,
    p.nome_pessoa,
    p.email_pessoa,
    u.tipo_usuario,
    u.senha_usuario
   FROM pessoa p
     JOIN usuario u ON p.id_pessoa = u.id_pessoa;
	 
-- FUNCTION PARA CADASTRAR NOVOS USUÁRIOS NO APP
CREATE FUNCTION fn_register_user(nomePessoa TEXT, sobrenomePessoa TEXT, emailPessoa TEXT, telefonePessoa TEXT, dataNascimentoPessoa TEXT, senhaUsuario TEXT)
	RETURNS BOOLEAN AS $$
	DECLARE idPessoa integer;
BEGIN
  INSERT INTO pessoa (nome_pessoa, sobrenome_pessoa, email_pessoa, telefone_pessoa, data_nascimento_pessoa, data_cadastro_pessoa, status_pessoa) 
  VALUES (nomePessoa, sobrenomePessoa, emailPessoa, telefonePessoa, TO_DATE(dataNascimentoPessoa, 'YYYY-MM-DD'), now(), 0) RETURNING id_pessoa INTO idPessoa;
  INSERT INTO usuario (tipo_usuario, senha_usuario, id_pessoa) 
  VALUES (0, senhaUsuario, idPessoa);
  RETURN TRUE;
EXCEPTION WHEN OTHERS THEN
  RETURN FALSE;
END;
