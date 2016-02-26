#! /bin/bash

# Copyright (c) 2014-2016 Solano Labs Inc. All Rights Reserved
# Script for uploading build artifacts: upload_object.sh
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SOLANO LABS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
# IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# https://github.com/aws/aws-cli
# S3 details: http://docs.aws.amazon.com/cli/latest/reference/s3/cp.html
#
# Usage:
# 1. Set AWS environment variables as below
# 2. Command line options:
#    -b: override bucket name
#    -f: set folder name inside bucket
# 3. Invocation:
#    upload_object.sh [options] path/to/object [upload_name]
#
#    Where path/to/object is file to upload
#    And upload_name is the optional name to use inside the named bucket
#
# Set AWS environment variables
#   See http://docs.solanolabs.com/Setup/setting-environment-variables/
#   Bucket should be just the bucket name, not the FQDN; defaults to builds
#   Edit sub-directory of bucket (if any) below
# solano config org UPLOAD_AWS_ACCESS_KEY_ID <key id>
# solano config org UPLOAD_AWS_SECRET_ACCESS_KEY <access key>
# solano config org UPLOAD_BUCKET <bucket host>

# Optionally set region if not us-east-1:
# solano config org UPLOAD_AWS_DEFAULT_REGION us-east-1

# You can add server-side encryption with the --sse flag to aws-cli

# If you are using python, we recommend adding aws-cli to your requirements.txt
# If you are not using python, aws-cli will be on the path in /usr/local/bin

# If you want to use client-side encryption and store the password in the
# config variable UPLOAD_PASSWORD then you can use GnuPG to encrypt/decrypt
# The following two examples use symmetric encryption only.  You can use
# the --output command line parameter to set the name of the output file
#
# Encrypt with passphrase $UPLOAD_PASSWORD
# exec 0<<<$UPLOAD_PASSWORD gpg --passphrase-fd=0 --symmetric $1
#
# Decrypt with passphrase $UPLOAD_PASSWORD
# exec 0<<<$UPLOAD_PASSWORD gpg -q --passphrase-fd=0 --decrypt $1
#set -x

if [ "`which aws`" == "" ]
then
  #echo "Installing aws-cli"
  date

  pip install --install-option="--prefix=$HOME" awscli || { exit 1; } 

  #echo "Installation of aws-cli complete"
  date
fi

if [ -d $HOME/lib/python2.7/site-packages ]
then
  export PYTHONPATH=$HOME/lib/python2.7/site-packages
fi

folder='solano-gem'       # sub-directory in s3 bucket (if any) to use
upload_options="--storage-class REDUCED_REDUNDANCY --acl public-read"

if [ -z $UPLOAD_BUCKET ]
then
  bucket=s3://builds
else
  bucket=$UPLOAD_BUCKET
fi

numargs=$#
for ((i=1 ; i <= numargs ; i++))
do
  case $1 in
  -b) bucket="$2"; shift; shift ;;
  -f) folder="$2"; shift; shift ;;
  *) break ;;
  esac
done

# Compute path to object to upload, e.g.:
object=$1
object_name=`basename $object` || { exit 1; }

if [ -z "$object" ] || [ -z "$object_name" ]
then
  echo "You must specify an object to upload" 1>&2
  exit 1
fi

# Compute a suitable name for the uploaded object, e.g.:
target=$object_name
if [ -z "$2" ]
then
  target="$bucket/$folder/`date +%s`-$object_name"
fi

export AWS_ACCESS_KEY_ID=${UPLOAD_AWS_ACCESS_KEY_ID:-${AWS_ACCESS_KEY_ID}}
export AWS_SECRET_ACCESS_KEY=${UPLOAD_AWS_SECRET_ACCESS_KEY:-${AWS_SECRET_ACCESS_KEY}}
export AWS_DEFAULT_REGION=${UPLOAD_AWS_DEFAULT_REGION:-${AWS_DEFAULT_REGION}}

case $bucket in
http*) ;;
s3*) ;;
*) bucket="s3://$bucket" ;;
esac

if [ -z $AWS_DEFAULT_REGION ]
then
  export AWS_DEFAULT_REGION=us-east-1
fi

#echo "Uploading build artifact"
output=`aws s3 cp $upload_options "$object" "$target"` || { echo "aws upload failed" ; exit 1; }

#echo "Upload complete"
public_url=`echo $target | sed "s/s3:\/\//https:\/\/s3.amazonaws.com\//g"`
echo $public_url
