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