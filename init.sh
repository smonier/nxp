#!/usr/bin/env bash

JAHIA_URL=http://localhost:8080

# This script controls the startup of the container environment
# It can be used as an alternative to having docker-compose up started by the CI environment
env_started="false"

# If Jahia takes more than MAX_START_TIME to become available
# The script will stop
MAX_START_TIME=1200
START_TIME=$SECONDS

healthcheck () {
    HEALTHCHECK=$(curl -sS -u root:root ${JAHIA_URL}/modules/graphql \
    -H "Origin: ${JAHIA_URL}" \
    -H 'content-type: application/json' \
    --data-raw '{"query":"\t\nquery {\n  admin {\n    jahia {\n      healthCheck(severity: LOW) {  # You minimum severity to return\n        status {                    # Highest reported status across all probes\n          health                    # GREEN, YELLOW or RED\n          message                   # Explanation for the health level\n        }\n      }\n    }\n  }\n}"}' 2>&1)

    if jq -e . >/dev/null 2>&1 <<<"$HEALTHCHECK"; then
        HEALTH=$(jq -r '.data.admin.jahia.healthCheck.status.health' <<< "$HEALTHCHECK")
        MESSAGE=$(jq -r '.data.admin.jahia.healthCheck.status.message' <<< "$HEALTHCHECK")
        if [[ "$HEALTH" == "GREEN" ]]; then
            echo "$(date +'%d %B %Y - %k:%M:%S') HealthCheck: Jahia has started and its status is GREEN ($MESSAGE) - ${JAHIA_URL}"
            env_started="true"
        else
            echo "$(date +'%d %B %Y - %k:%M:%S') HealthCheck: Jahia is still starting (SAM Status => $HEALTH : $MESSAGE) - ${JAHIA_URL}"
        fi
    else
        echo "$(date +'%d %B %Y - %k:%M:%S') HealthCheck: Invalid response - Jahia and SAM have not started yet. - ${JAHIA_URL}"
    fi
}

docker compose up -d

echo "$(date +'%d %B %Y - %k:%M:%S') == Waiting for Jahia to startup"

while true; do
    healthcheck
    if [[ "$env_started" == "true" ]]; then
        break
    fi
    ELAPSED_TIME=$(($SECONDS - $START_TIME))
    if [[ $ELAPSED_TIME -gt $MAX_START_TIME ]]; then
        echo "$(date +'%d %B %Y - %k:%M:%S') Jahia took more than $MAX_START_TIME seconds to start, exiting... "
        exit 1
    fi
    sleep 5
done

#VARIABLES=$(curl -s http://localhost:8080/sites/systemsite/home.oauth-id-redirect.do?users=json)

curl -u root:root -X POST http://localhost:8080/modules/graphql -H "Origin: http://localhost:8080" --form query='mutation {
  jcr {
    pdfs: addNode(
      name: "pdfs"
      parentPathOrId: "/sites/systemsite/files"
      primaryNodeType: "jnt:folder"
    ) {
      guest: revokeRoles(
        roleNames: ["reader"]
        principalType: USER
        principalName: "guest"
      )
    }
    truck: addNode(
      name: "truck.pdf"
      parentPathOrId: "/sites/systemsite/files/pdfs"
      primaryNodeType: "jnt:file"
    ) {
      addChild(name: "jcr:content", primaryNodeType: "jnt:resource") {
        content: mutateProperty(name: "jcr:data") {
          setValue(type: BINARY, value: "truck")
        }
        contentType: mutateProperty(name: "jcr:mimeType") {
          setValue(value: "application/pdf")
        }
      }
      users: revokeRoles(
        roleNames: ["reader"]
        principalType: GROUP
        principalName: "users"
      )
      blachance1: grantRoles(
        roleNames: ["reader"]
        principalType: USER
        principalName: "bob.lachance.1@example.com"
      )
    }
    bike: addNode(
      name: "bike.pdf"
      parentPathOrId: "/sites/systemsite/files/pdfs"
      primaryNodeType: "jnt:file"
    ) {
      addChild(name: "jcr:content", primaryNodeType: "jnt:resource") {
        content: mutateProperty(name: "jcr:data") {
          setValue(type: BINARY, value: "bike")
        }
        contentType: mutateProperty(name: "jcr:mimeType") {
          setValue(value: "application/pdf")
        }
      }
      users: revokeRoles(
        roleNames: ["reader"]
        principalType: GROUP
        principalName: "users"
      )
      blachance1: grantRoles(
        roleNames: ["reader"]
        principalType: USER
        principalName: "bob.lachance.1@example.com"
      )
    }
    electric: addNode(
      name: "electric.pdf"
      parentPathOrId: "/sites/systemsite/files/pdfs"
      primaryNodeType: "jnt:file"
    ) {
      addChild(name: "jcr:content", primaryNodeType: "jnt:resource") {
        content: mutateProperty(name: "jcr:data") {
          setValue(type: BINARY, value: "electric")
        }
        contentType: mutateProperty(name: "jcr:mimeType") {
          setValue(value: "application/pdf")
        }
      }
      users: revokeRoles(
        roleNames: ["reader"]
        principalType: GROUP
        principalName: "users"
      )
      blachance1: grantRoles(
        roleNames: ["reader"]
        principalType: USER
        principalName: "bob.lachance.1@example.com"
      )
      blachance2: grantRoles(
        roleNames: ["reader"]
        principalType: USER
        principalName: "bob.lachance.2@example.com"
      )
    }
    car: addNode(
      name: "car.pdf"
      parentPathOrId: "/sites/systemsite/files/pdfs"
      primaryNodeType: "jnt:file"
    ) {
      addChild(name: "jcr:content", primaryNodeType: "jnt:resource") {
        content: mutateProperty(name: "jcr:data") {
          setValue(type: BINARY, value: "car")
        }
        contentType: mutateProperty(name: "jcr:mimeType") {
          setValue(value: "application/pdf")
        }
      }
      users: revokeRoles(
        roleNames: ["reader"]
        principalType: GROUP
        principalName: "users"
      )
      blachance2: grantRoles(
        roleNames: ["reader"]
        principalType: USER
        principalName: "bob.lachance.2@example.com"
      )
      blachance3: grantRoles(
        roleNames: ["reader"]
        principalType: USER
        principalName: "bob.lachance.3@example.com"
      )
    }
    universal: addNode(
      name: "universal.pdf"
      parentPathOrId: "/sites/systemsite/files/pdfs"
      primaryNodeType: "jnt:file"
    ) {
      addChild(name: "jcr:content", primaryNodeType: "jnt:resource") {
        content: mutateProperty(name: "jcr:data") {
          setValue(type: BINARY, value: "universal")
        }
        contentType: mutateProperty(name: "jcr:mimeType") {
          setValue(value: "application/pdf")
        }
      }
      users: revokeRoles(
        roleNames: ["reader"]
        principalType: GROUP
        principalName: "users"
      )
      blachance1: grantRoles(
        roleNames: ["reader"]
        principalType: USER
        principalName: "bob.lachance.1@example.com"
      )
      blachance2: grantRoles(
        roleNames: ["reader"]
        principalType: USER
        principalName: "bob.lachance.2@example.com"
      )
      blachance3: grantRoles(
        roleNames: ["reader"]
        principalType: USER
        principalName: "bob.lachance.3@example.com"
      )
    }
  }
}' --form truck=@pdfs/truck.pdf --form bike=@pdfs/bike.pdf --form electric=@pdfs/electric.pdf --form car=@pdfs/car.pdf --form universal=@pdfs/universal.pdf


curl -u root:root -X POST http://localhost:8080/modules/graphql -H "Origin: http://localhost:8080" --form query='mutation {
  jcr {
    mutateNode(pathOrId: "/sites/systemsite/files/pdfs") {
      publish(includeSubTree: true, languages: ["en", "fr", "de", "pt", "it", "es"])
    }
  }
}'

npx http-server -p 1986
