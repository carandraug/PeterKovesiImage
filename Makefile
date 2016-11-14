## Copyright (C) 2016 Carnë Draug <carandraug+dev@gmail.com>
##
## Copying and distribution of this file, with or without modification,
## are permitted in any medium without royalty provided the copyright
## notice and this notice are preserved.  This file is offered as-is,
## without any warranty.

UPSTREAM_RELASE := http://www.peterkovesi.com/MatlabFns.zip

DOWNLOAD_DIR := target
DOWNLOADED_ZIPFILE := $(DOWNLOAD_DIR)/$(notdir $(UPSTREAM_RELASE))
DOWNLOADED_CONTENTS := $(basename $(DOWNLOADED_ZIPFILE))

UNZIP ?= unzip
RSYNC ?= rsync
GIT ?= git

DATE := $(shell date)

update: $(DOWNLOADED_ZIPFILE) | $(DOWNLOAD_DIR)
	$(UNZIP) $< -x .DS_Store -d $(DOWNLOAD_DIR)
	$(RSYNC) --archive --delete \
	  --exclude=$(DOWNLOAD_DIR) \
	  --exclude=".git/" \
	  --exclude=".gitignore" \
	  --exclude="Makefile" \
	  "$(DOWNLOADED_CONTENTS)/" "./"
	$(GIT) add --all
	$(GIT) commit -m "update with upstream release as of $(DATE)"

## dependent on clean, always download a fresh release
$(DOWNLOADED_ZIPFILE): clean | $(DOWNLOAD_DIR)
	wget --quiet --output-document="$@" $(UPSTREAM_RELASE)

$(DOWNLOAD_DIR):
	mkdir -p $@

clean:
	$(RM) $(DOWNLOADED_ZIPFILE)
	$(RM) -r $(DOWNLOADED_CONTENTS)
