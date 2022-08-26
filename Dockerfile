## Attempting to make this as compatible with Iron Bank as possible
## Matching current version on Iron Bank
FROM bitnami/git:2.35.2 AS fetcher
ARG RELEASE=0.2.0
RUN git clone --recurse-submodules -b v${RELEASE} https://github.com/usnistgov/oscal-cli.git  /oscal-cli/

## Matching current version on Iron Bank
FROM maven:3.8.5-openjdk-17 AS builder
COPY --from=fetcher /oscal-cli/ /oscal-cli/
WORKDIR /oscal-cli/
RUN mvn install

## Chose GCR as google also contributes a java image to Iron Bank
FROM gcr.io/distroless/java11-debian11
ARG RELEASE=0.2.0
COPY --from=builder /oscal-cli/cli-core/target/cli-core-${RELEASE}-oscal-cli/lib/* /usr/lib/oscal-cli/
COPY --from=builder /oscal-cli/cli-core/target/cli-core-${RELEASE}-oscal-cli/bin/oscal-cli /usr/bin/oscal-cli
ENV CLASSPATH=/usr/lib/oscal-cli/gov.nist.secauto.oscal.tools.oscal-cli.cli-core-${RELEASE}.jar:/usr/lib/oscal-cli/gov.nist.secauto.oscal.tools.oscal-cli.cli-framework-${RELEASE}.jar:/usr/lib/*commons-cli.commons-cli-1.5.0.jar:/usr/lib/*org.apache.logging.log4j.log4j-jul-2.18.0.jar:/usr/lib/*gov.nist.secauto.oscal.liboscal-java-1.0.4.2.jar:/usr/lib/*gov.nist.secauto.metaschema.metaschema-java-binding-0.9.0.jar:/usr/lib/*com.fasterxml.jackson.dataformat.jackson-dataformat-xml-2.13.3.jar:/usr/lib/*com.fasterxml.jackson.core.jackson-annotations-2.13.3.jar:/usr/lib/*com.fasterxml.jackson.core.jackson-databind-2.13.3.jar:/usr/lib/*org.codehaus.woodstox.stax2-api-4.2.1.jar:/usr/lib/*org.apache.commons.commons-lang3-3.12.0.jar:/usr/lib/*org.apache.logging.log4j.log4j-api-2.18.0.jar:/usr/lib/*gov.nist.secauto.metaschema.metaschema-schema-generator-0.9.0.jar:/usr/lib/*gov.nist.secauto.metaschema.metaschema-model-0.9.0.jar:/usr/lib/*org.apache.xmlbeans.xmlbeans-5.1.0.jar:/usr/lib/*gov.nist.secauto.metaschema.metaschema-model-common-0.9.0.jar:/usr/lib/*org.antlr.antlr4-runtime-4.10.1.jar:/usr/lib/*com.fasterxml.woodstox.woodstox-core-6.3.1.jar:/usr/lib/*com.fasterxml.jackson.core.jackson-core-2.13.3.jar:/usr/lib/*com.fasterxml.jackson.dataformat.jackson-dataformat-yaml-2.13.3.jar:/usr/lib/*org.yaml.snakeyaml-1.30.jar:/usr/lib/*com.vladsch.flexmark.flexmark-0.64.0.jar:/usr/lib/*com.vladsch.flexmark.flexmark-util-ast-0.64.0.jar:/usr/lib/*org.jetbrains.annotations-15.0.jar:/usr/lib/*com.vladsch.flexmark.flexmark-util-builder-0.64.0.jar:/usr/lib/*com.vladsch.flexmark.flexmark-util-collection-0.64.0.jar:/usr/lib/*com.vladsch.flexmark.flexmark-util-data-0.64.0.jar:/usr/lib/*com.vladsch.flexmark.flexmark-util-dependency-0.64.0.jar:/usr/lib/*com.vladsch.flexmark.flexmark-util-format-0.64.0.jar:/usr/lib/*com.vladsch.flexmark.flexmark-util-html-0.64.0.jar:/usr/lib/*com.vladsch.flexmark.flexmark-util-misc-0.64.0.jar:/usr/lib/*com.vladsch.flexmark.flexmark-util-sequence-0.64.0.jar:/usr/lib/*com.vladsch.flexmark.flexmark-util-visitor-0.64.0.jar:/usr/lib/*com.vladsch.flexmark.flexmark-ext-tables-0.64.0.jar:/usr/lib/*com.vladsch.flexmark.flexmark-util-0.64.0.jar:/usr/lib/*com.vladsch.flexmark.flexmark-util-options-0.64.0.jar:/usr/lib/*com.vladsch.flexmark.flexmark-ext-escaped-character-0.64.0.jar:/usr/lib/*com.vladsch.flexmark.flexmark-ext-superscript-0.64.0.jar:/usr/lib/*com.vladsch.flexmark.flexmark-ext-gfm-strikethrough-0.64.0.jar:/usr/lib/*com.vladsch.flexmark.flexmark-ext-typographic-0.64.0.jar:/usr/lib/*com.vladsch.flexmark.flexmark-html2md-converter-0.64.0.jar:/usr/lib/*com.vladsch.flexmark.flexmark-ext-emoji-0.64.0.jar:/usr/lib/*com.vladsch.flexmark.flexmark-jira-converter-0.64.0.jar:/usr/lib/*com.vladsch.flexmark.flexmark-ext-wikilink-0.64.0.jar:/usr/lib/*com.vladsch.flexmark.flexmark-ext-ins-0.64.0.jar:/usr/lib/*org.jsoup.jsoup-1.14.3.jar:/usr/lib/*com.github.seancfoley.ipaddress-5.3.4.jar:/usr/lib/*nl.talsmasoftware.lazy4j-1.0.2.jar:/usr/lib/*org.jdom.jdom2-2.0.6.1.jar:/usr/lib/*jaxen.jaxen-1.2.0.jar:/usr/lib/*org.xmlresolver.xmlresolver-4.5.1.jar:/usr/lib/*org.apache.httpcomponents.client5.httpclient5-5.1.3.jar:/usr/lib/*org.apache.httpcomponents.core5.httpcore5-h2-5.1.3.jar:/usr/lib/*org.slf4j.slf4j-api-1.7.25.jar:/usr/lib/*commons-codec.commons-codec-1.15.jar:/usr/lib/*org.apache.httpcomponents.core5.httpcore5-5.1.3.jar:/usr/lib/*org.apache.logging.log4j.log4j-core-2.18.0.jar:/usr/lib/*org.fusesource.jansi.jansi-2.4.0.jar:/usr/lib/*commons-io.commons-io-2.11.0.jar:/usr/lib/*net.sf.saxon.Saxon-HE-11.4.jar:/usr/lib/*org.xmlresolver.xmlresolver-4.4.3.jar:/usr/lib/*xml-apis.xml-apis-1.4.01.jar:/usr/lib/*com.github.erosb.everit-json-schema-1.14.1.jar:/usr/lib/*org.json.json-20220320.jar:/usr/lib/*commons-validator.commons-validator-1.7.jar:/usr/lib/*commons-digester.commons-digester-2.1.jar:/usr/lib/*commons-logging.commons-logging-1.2.jar:/usr/lib/*commons-collections.commons-collections-3.2.2.jar:/usr/lib/*com.damnhandy.handy-uri-templates-2.1.8.jar:/usr/lib/*joda-time.joda-time-2.10.2.jar:/usr/lib/oscal-cli/com.google.re2j.re2j-1.6.jar

VOLUME [ "/WORKING" ]
WORKDIR /WORKING
ENTRYPOINT ["java", \
    "-Dsun.stdout.encoding=UTF-8", \
    "-Dsun.stderr.encoding=UTF-8", \
    "-Dapp.name='oscal-cli'", \
    "-Dapp.home='/usr/lib/oscal-cli/'",\
    "gov.nist.secauto.oscal.tools.cli.core.CLI"]