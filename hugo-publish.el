(defun mlemosf/hugo-add-file-headers (filename title author tags)
  ;; Adiciona os cabeçalhos necessários para geração de sites no Hugo
  (let (
        (tempbuffer (find-file filename)))
    (with-current-buffer tempbuffer
      (progn
        (insert "+++\n")
        (insert (format "title = \"%s\"\n" title))
        (insert (format "date = \"%s\"\n" (format-time-string "%Y-%m-%dT%T")))
        (insert (format "author = \"%s\"\n" author))
        (insert (format "tags = [%s]\n" (s-join ","
                                                (mapcar
                                                 '(lambda (x) (format "\"%s\"" x))
                                                 tags))))
        (insert "description = \"test description\"\n")
        (insert "draft = false\n")
        (insert "+++\n")
        (write-file filename)
        (kill-buffer tempbuffer)))))

(defun mlemosf/hugo-export-to-md-and-move ()
  ;; Converte o arquivo org atual para markdown e move para a pasta selecionada
  (interactive)
  (let* (
        (buffername (buffer-file-name))
        (title (read-string "Título: "))
        (author (read-string "Author: "))
        (tags (split-string (read-string "Tags: ")))
        (markdown-folder (read-file-name "Pasta de exportação: "))
        (origin-filename (concat (file-name-sans-extension buffername) ".md"))
        (destination-filename (concat markdown-folder (file-name-nondirectory (file-name-sans-extension buffername)) ".md")))
    (progn
      (org-md-export-to-markdown)
      (mlemosf/hugo-add-file-headers origin-filename title author tags)
      (rename-file origin-filename destination-filename t)
      (message "Arquivo exportado com sucesso"))))
