.PHONY: all html check_deploy deploy clean deepclean draft set-draft

ifndef GEMS
GEMS = env
endif
HTML_FILE = index.html
PDF_FILE = hands-on.pdf
SOLUTIONS_DIR = solutions
CHEATSHEET_HTML = cheatsheet.html
CHEATSHEET_PDF = cheatsheet.pdf
STYLESHEETS_DIR = css
ASSETS_DIR = assets
README = hands-on.adoc
CHEATSHEET = cheatsheet.adoc
SOLUTIONS = $(wildcard $(SOLUTIONS_DIR)/*.adoc)
SOLUTIONS_HTML = $(SOLUTIONS:%.adoc=%.html)
DEPLOY_LIST = deploy-list.txt
PDF = pdf
PDF_STYLE = crg
ATTRS = -a allow-uri-read

all: html pdf

draft: set-draft html 	
set-draft:
	$(eval ATTRS += -a draft)

html: setup $(HTML_FILE) $(CHEATSHEET_HTML) $(SOLUTIONS_HTML)
$(HTML_FILE): $(README) *.adoc
	@GEM_HOME=$(GEMS) $(GEMS)/bin/asciidoctor $(README) $(ATTRS) -o $(HTML_FILE)
	@echo == Written file $(HTML_FILE)

$(CHEATSHEET_HTML): $(CHEATSHEET) *.adoc
	@GEM_HOME=$(GEMS) $(GEMS)/bin/asciidoctor $(CHEATSHEET) -o $(CHEATSHEET_HTML)
	@echo == Written file $(CHEATSHEET_HTML)

$(SOLUTIONS_HTML): ATTRS = -a nofooter -a linkcss -a stylesdir=../css -a stylesheet=crg.css -a hide-uri-scheme -a icons=font -a source-highlighter=highlight.js -a highlightjs-theme=github
$(SOLUTIONS_HTML): %.html: %.adoc solutions/*.adoc
	@GEM_HOME=$(GEMS) $(GEMS)/bin/asciidoctor $< $(ATTRS) -o $@
	@echo == Written file $@

pdf: setup $(PDF_FILE) $(CHEATSHEET_PDF) *.adoc
$(PDF_FILE): $(README)
	@GEM_HOME=$(GEMS) $(GEMS)/bin/asciidoctor-pdf $(README) -a pdf-stylesdir=$(PDF)/style -a pdf-style=$(PDF_STYLE) -a pdf-fontsdir=$(PDF)/font
	@echo == Written file $(PDF_FILE)

$(CHEATSHEET_PDF): $(CHEATSHEET)
	@GEM_HOME=$(GEMS) $(GEMS)/bin/asciidoctor-pdf $(CHEATSHEET) -a pdf-stylesdir=$(PDF)/style -a pdf-style=$(PDF_STYLE) -a pdf-fontsdir=$(PDF)/font
		@echo == Written file $(CHEATSHEET_PDF)

setup: $(GEMS)/bin/asciidoctor $(GEMS)/bin/asciidoctor-pdf

$(GEMS)/bin/asciidoctor: $(GEMS)
	@GEM_HOME=$(GEMS) $(GEMS)/bin/bundle --path=$(GEMS) --binstubs=$(GEMS)/bin

$(GEMS): $(GEMS)/bin/bundle
$(GEMS)/bin/bundle:
	@GEM_HOME=$(GEMS) gem install bundler

$(DEPLOY_LIST):
	@echo $(HTML_FILE) >> $(DEPLOY_LIST)
	@echo $(CHEATSHEET_HTML) >> $(DEPLOY_LIST)
	@echo $(ASSETS_DIR) >> $(DEPLOY_LIST)
	@echo $(STYLESHEETS_DIR) >> $(DEPLOY_LIST)
	@echo $(SOLUTIONS_DIR)/.htaccess >> $(DEPLOY_LIST)
	@echo $(SOLUTIONS_HTML) | tr ' ' '\n' >> $(DEPLOY_LIST)

check_deploy:
ifndef RNASEQ_DEPLOY_DIR
	$(error Undefined variable RNASEQ_DEPLOY_DIR)
endif

deploy: html $(DEPLOY_LIST) check_deploy
	rsync -ar --files-from=$(DEPLOY_LIST) . $(RNASEQ_DEPLOY_DIR)

deploy-draft: draft $(DEPLOY_LIST) check_deploy
	rsync -ar --files-from=$(DEPLOY_LIST) . $(RNASEQ_DEPLOY_DIR)


clean:
	rm -f $(HTML_FILE) $(CHEATSHEET_HTML) $(PDF_FILE) $(CHEATSHEET_PDF) $(DEPLOY_LIST)

deepclean: clean
	rm -rf $(GEMS) bin .bundle
