CREATE OR REPLACE VIEW v_pessoa AS
SELECT pessoa.id_pessoa,
       pessoa.nome_pessoa,
       pessoa.sobrenome_pessoa,
       pessoa.email_pessoa,
       pessoa.telefone_pessoa,
       to_char((pessoa.data_nascimento_pessoa)::timestamp with time zone, 'YYYY-mm-dd'::text) AS data_nascimento_pessoa,
       to_char((pessoa.data_cadastro_pessoa)::timestamp with time zone, 'YYYY-mm-dd'::text)   AS data_cadastro_pessoa,
       pessoa.status_pessoa
FROM pessoa;

CREATE OR REPLACE VIEW v_docs AS
SELECT d.id_documento,
       d.titulo_documento,
       d.sinopse_documento,
       to_char((d.data_publicacao_documento)::timestamp with time zone,
               'YYYY-mm-dd'::text) AS data_publicacao_documento,
       c.descricao_categoria,
       e.descricao_editora
FROM documento d
         INNER JOIN categoria c on d.id_categoria = c.id_categoria
         INNER JOIN editora e on d.id_editora = e.id_editora
WHERE d.status_documento = 0
ORDER BY d.data_publicacao_documento DESC;

CREATE OR REPLACE VIEW v_docs_info AS
SELECT d.id_documento,
       d.titulo_documento,
       d.sinopse_documento,
       to_char((d.data_publicacao_documento)::timestamp with time zone,
               'YYYY-mm-dd'::text) AS data_publicacao_documento,
       c.descricao_categoria,
       e.descricao_editora
FROM documento d
         INNER JOIN categoria c on d.id_categoria = c.id_categoria
         INNER JOIN editora e on d.id_editora = e.id_editora
WHERE d.status_documento = 1
ORDER BY d.data_publicacao_documento DESC;

CREATE OR REPLACE VIEW v_login AS
SELECT p.id_pessoa, p.nome_pessoa, p.email_pessoa, u.tipo_usuario, u.senha_usuario
FROM pessoa p
         INNER JOIN usuario u ON p.id_pessoa = u.id_pessoa;

CREATE OR REPLACE FUNCTION fn_register_user(nomePessoa TEXT, sobrenomePessoa TEXT, emailPessoa TEXT, telefonePessoa TEXT, dataNascimentoPessoa TEXT, senhaUsuario TEXT)
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

$$ LANGUAGE plpgsql;