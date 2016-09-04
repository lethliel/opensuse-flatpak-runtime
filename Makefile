PROXY=
VERSION=1
ARCH=x86_64
TARGET_DIR=/tmp/flat
C_USER = $(shell whoami)


all: platform sdk 

clean:
	rm -rf $(TARGET_DIR)/repo $(TARGET_DIR)/exportrepo
	sudo rm -fr $(TARGET_DIR)/buildroot $(TARGET_DIR)/buildroot-prepare $(TARGET_DIR)/.commit-*

exportrepo/config:
	sudo mkdir -p $(TARGET_DIR)
	sudo chown -R $(C_USER) $(TARGET_DIR)
	if [ ! -e $(TARGET_DIR)/exportrepo ] ; \
        then \
		ostree init --repo=$(TARGET_DIR)/exportrepo --mode=archive-z2 ; \
	fi ;

repo/refs/heads/base/org.openSUSE.Runtime/$(ARCH)/$(VERSION): leap-42.1.kiwi config.sh
	sudo mkdir -p $(TARGET_DIR)
	sudo chown -R $(C_USER) $(TARGET_DIR)
	if [ ! -e $(TARGET_DIR)/repo ] ; \
	then \
		ostree init --repo=$(TARGET_DIR)/repo ; \
	fi ; \
	sudo rm -rf $(TARGET_DIR)/buildroot
	sudo kiwi --prepare $$PWD --add-profile="runtime" --root=$(TARGET_DIR)/buildroot 
	sudo ./prepare-to-ostree.sh
	sudo ostree --repo=$(TARGET_DIR)/repo commit -s 'initial build' -b base/org.openSUSE.Runtime/$(ARCH)/$(VERSION) --tree="dir=$(TARGET_DIR)/buildroot-prepare"

repo/refs/heads/base/org.openSUSE.Sdk/$(ARCH)/$(VERSION): leap-42.1.kiwi config.sh
	sudo rm -rf $(TARGET_DIR)/buildroot
	sudo mkdir -p $(TARGET_DIR)
	sudo kiwi --prepare $$PWD --add-profile="sdk" --root=$(TARGET_DIR)/buildroot 
	sudo ./prepare-to-ostree.sh
	sudo ostree --repo=$(TARGET_DIR)/repo commit -s 'initial build' -b base/org.openSUSE.Sdk/$(ARCH)/$(VERSION) --tree="dir=$(TARGET_DIR)/buildroot-prepare"

repo/refs/heads/runtime/org.openSUSE.Runtime/$(ARCH)/$(VERSION): repo/refs/heads/base/org.openSUSE.Runtime/$(ARCH)/$(VERSION) metadata.runtime
	./commit-subtree.sh base/org.openSUSE.Runtime/$(ARCH)/$(VERSION) runtime/org.openSUSE.Runtime/$(ARCH)/$(VERSION) metadata.runtime /files files

repo/refs/heads/runtime/org.openSUSE.Runtime.Var/$(ARCH)/$(VERSION): repo/refs/heads/base/org.openSUSE.Runtime/$(ARCH)/$(VERSION) metadata.runtime
	./commit-subtree.sh base/org.openSUSE.Runtime/$(ARCH)/$(VERSION) runtime/org.openSUSE.Runtime.Var/$(ARCH)/$(VERSION) metadata.runtime /var files
	#./commit-subtree.sh base/org.openSUSE.Runtime/$(ARCH)/$(VERSION) runtime/org.openSUSE.Runtime.Var/$(ARCH)/$(VERSION) metadata.runtime /var files /usr/share/rpm files/lib/rpm

repo/refs/heads/runtime/org.openSUSE.Sdk/$(ARCH)/$(VERSION): repo/refs/heads/base/org.openSUSE.Sdk/$(ARCH)/$(VERSION) metadata.sdk
	./commit-subtree.sh base/org.openSUSE.Sdk/$(ARCH)/$(VERSION) runtime/org.openSUSE.Sdk/$(ARCH)/$(VERSION) metadata.sdk /files files

repo/refs/heads/runtime/org.openSUSE.Sdk.Var/$(ARCH)/$(VERSION): repo/refs/heads/base/org.openSUSE.Sdk/$(ARCH)/$(VERSION) metadata.sdk
	./commit-subtree.sh base/org.openSUSE.Sdk/$(ARCH)/$(VERSION) runtime/org.openSUSE.Sdk.Var/$(ARCH)/$(VERSION) metadata.sdk /var files 
	#./commit-subtree.sh base/org.openSUSE.Sdk/$(ARCH)/$(VERSION) runtime/org.openSUSE.Sdk.Var/$(ARCH)/$(VERSION) metadata.sdk /var files /usr/share/rpm files/lib/rpm

exportrepo/refs/heads/runtime/org.openSUSE.Runtime/$(ARCH)/$(VERSION): repo/refs/heads/runtime/org.openSUSE.Runtime/$(ARCH)/$(VERSION) exportrepo/config
	ostree pull-local --repo=$(TARGET_DIR)/exportrepo $(TARGET_DIR)/repo runtime/org.openSUSE.Runtime/$(ARCH)/$(VERSION)
	flatpak build-update-repo $(TARGET_DIR)/exportrepo

exportrepo/refs/heads/runtime/org.openSUSE.Runtime.Var/$(ARCH)/$(VERSION): repo/refs/heads/runtime/org.openSUSE.Runtime.Var/$(ARCH)/$(VERSION) exportrepo/config
	ostree pull-local --repo=$(TARGET_DIR)/exportrepo $(TARGET_DIR)/repo runtime/org.openSUSE.Runtime.Var/$(ARCH)/$(VERSION)
	flatpak build-update-repo $(TARGET_DIR)/exportrepo

exportrepo/refs/heads/runtime/org.openSUSE.Sdk/$(ARCH)/$(VERSION): repo/refs/heads/runtime/org.openSUSE.Sdk/$(ARCH)/$(VERSION) exportrepo/config
	ostree pull-local --repo=$(TARGET_DIR)/exportrepo $(TARGET_DIR)/repo runtime/org.openSUSE.Sdk/$(ARCH)/$(VERSION)
	flatpak build-update-repo $(TARGET_DIR)/exportrepo

exportrepo/refs/heads/runtime/org.openSUSE.Sdk.Var/$(ARCH)/$(VERSION): repo/refs/heads/runtime/org.openSUSE.Sdk.Var/$(ARCH)/$(VERSION) exportrepo/config
	ostree pull-local --repo=$(TARGET_DIR)/exportrepo $(TARGET_DIR)/repo runtime/org.openSUSE.Sdk.Var/$(ARCH)/$(VERSION)
	flatpak build-update-repo $(TARGET_DIR)/exportrepo

platform: exportrepo/refs/heads/runtime/org.openSUSE.Runtime/$(ARCH)/$(VERSION) exportrepo/refs/heads/runtime/org.openSUSE.Runtime.Var/$(ARCH)/$(VERSION)
sdk: exportrepo/refs/heads/runtime/org.openSUSE.Sdk/$(ARCH)/$(VERSION) exportrepo/refs/heads/runtime/org.openSUSE.Sdk.Var/$(ARCH)/$(VERSION) 

