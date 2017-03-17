#!/bin/bash

export PATH=/home/gitlab-runner/.nvm/versions/node/v6.10.0/bin:$PATH

STATUSFILE="/home/gitlab-runner/master-status.txt"
BUILDFILEPATH=$1
DATETIME=`date +"%b %d, %Y %H:%M:%S"`
MAILTO='saurav.bora@laitkor.com,sa.rahul@laitkor.com,vijay.kumar@laitkor.com,sanjay.pal@laitkor.com,ajay.mishra@laitkor.com,arvind.rawat@laitkor.com,Yasser.Sheikh@laitkor.com,maxgorbs@gmail.com'

cd ${BUILDFILEPATH}
npm install
npm run build

if grep -q "Chris" build/js/*.js; then

        cd ${BUILDFILEPATH}/src/shared/components/Loader

        npm test 2>&1 | tee ${STATUSFILE}

        if grep -q "failed" ${STATUSFILE}; then
           echo  "`date` : Test Failed " >> $STATUSFILE
           echo "Build is not deployed as test is failed. Also find test result in the attachement" | mail -s "[Branch: master] FP Test Cases Failed | ${DATETIME}" ${MAILTO} -A ${STATUSFILE}
        else
                cd ${BUILDFILEPATH}
                cp -r build/* /home/gitlab-runner/website/demo.footprintlabs.co/
                echo "Build is successfully deployed to http://demo.footprintlabs.co. Test result is in the attachement" | mail -s "[Branch: master] FP Build & Test Cases Success | ${DATETIME}" ${MAILTO} -A ${STATUSFILE}
        fi
else
        echo "Footprint Prototype failed during build" | mail -s "[Branch: master] FP Build Failed | ${DATETIME}" ${MAILTO}
fi

