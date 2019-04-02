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

CREATE OR REPLACE FUNCTION fn_login(email text, senha text)
    RETURNS TABLE
            (
                id_pessoa INTEGER
            ) AS
$body$
SELECT p.id_pessoa
FROM pessoa p
         INNER JOIN usuario u ON p.id_pessoa = u.id_pessoa
WHERE p.email_pessoa = $1
  AND u.senha_usuario = ENCODE(DIGEST($2, 'sha256'), 'hex')
$body$
    LANGUAGE SQL;




