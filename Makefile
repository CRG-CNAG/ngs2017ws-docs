.PHONY: all html check_deploy deploy clean deepclean draft set-draft

ifndef GEMS
GEMS = env
endif
HTML_FILE = index.html
PDF_FILE = hands-on.pdf
CHEATSHEET_HTML = cheatsheet.html
CHEATSHEET_PDF = cheatsheet.pdf
SOLUTIONS_HTML = solutions/index.html
STYLESHEETS_DIR = css
ASSETS_DIR = assets
README = hands-on.adoc
CHEATSHEET = cheatsheet.adoc
SOLUTIONS = solutions/solutions.adoc
DEPLOY_LIST = deploy-list.txt
PDF = pdf
PDF_STYLE = crg
ATTRS = -a allow-uri-read

all: html pdf

draft: set-draft html 	
set-draft:
	$(eval ATTRS += -a draft)

html: $(HTML_FILE) $(CHEATSHEET_HTML) $(SOLUTIONS_HTML)
$(HTML_FILE): setup $(README)
	@GEM_HOME=$(GEMS) $(GEMS)/bin/asciidoctor $(README) $(ATTRS) -o $(HTML_FILE)
	@echo == Written file $(HTML_FILE)

$(CHEATSHEET_HTML): setup $(CHEATSHEET)
	@GEM_HOME=$(GEMS) $(GEMS)/bin/asciidoctor $(CHEATSHEET) -o $(CHEATSHEET_HTML)
	@echo == Written file $(CHEATSHEET_HTML)

$(SOLUTIONS_HTML): setup $(SOLUTIONS)
	@GEM_HOME=$(GEMS) $(GEMS)/bin/asciidoctor $(SOLUTIONS) -o $(SOLUTIONS_HTML)
	@echo == Written file $(SOLUTIONS_HTML)

pdf: $(PDF_FILE) $(CHEATSHEET_PDF)
$(PDF_FILE): setup $(README)
	@GEM_HOME=$(GEMS) $(GEMS)/bin/asciidoctor-pdf $(README) -a pdf-stylesdir=$(PDF)/style -a pdf-style=$(PDF_STYLE) -a pdf-fontsdir=$(PDF)/font
	@echo == Written file $(PDF_FILE)

$(CHEATSHEET_PDF): setup $(CHEATSHEET)
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
