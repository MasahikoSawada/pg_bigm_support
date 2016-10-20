RPMBUILD="./rpmbuild"
RPMTEST="./rpmtest"
VERSIONS="9.1 9.2 9.3 9.4 9.5 9.6"

SPECFILE_TEMPLATE=$1
CURRENT=`pwd`
LOGFILE="`date +"%Y%m%d_%Y%M%S"`.log"

function info
{
    echo "[INFO]: " $* | tee -a ${LOGFILE}
}

if [ "$#" -ne 1 ];then
    info "Invalid argument."
    info "Usage:"
    info "    $ ./generate_rpm.sh pg_bigm.spec"
    exit 1
fi

for version in `echo $VERSIONS`
do
    echo "======================== ${version} ========================" | tee -a ${LOGFILE}
    version1=`echo ${version} | cut -d. -f 1`
    version2=`echo ${version} | cut -d. -f 2`
    PGHOME="/usr/pgsql-${version1}.${version2}"
    PGBIN="${PGHOME}/bin"

    info "Building version ${version}  ..."
    
   # Install postgresql
    info "Installing postgresql"
    sudo yum install -y install $RPMTEST/$version/*

    # Update spec file
    specfile="${RPMBUILD}/SPECS/pg_bigm.spec"
    sed "s/XXX/${version1}/" ${SPECFILE_TEMPLATE} | sed "s/YYY/${version2}/" | sed "s@ZZZ@${CURRENT}/rpmbuild@" > ${specfile}

    # Building pg_bigm rpm
    info "Building pg_bigm rpm"
    rpmbuild -ba ${specfile}

    # Installing pg_bigm rpm
    rpmfile=`ls -1 ${RPMBUILD}/RPMS/x86_64/pg_bigm*pg${version1}${version2}*`
    info "Installing pg_bigm rpm : ${rpmfile}"
    sudo yum -y install ${rpmfile}

    # Confirm installation
    info "Confirm installation of pg_bigm"
    info "rpm -qip ${rpmfile}"
    rpm -qip ${rpmfile} | tee -a ${LOGFILE}
    info "rpm -qRp ${rpmfile}"
    rpm -qRp ${rpmfile} | tee -a ${LOGFILE}

    # Must be pg_bigm--1.0--1.1.sql, pg_bigm--1.1--1.2.sql, pg_bigm--1.2.sql, pg_bigm.control
    info "ls -l ${PGHOME}/share/extension | grep pg_bigm"
    ls -l ${PGHOME}/share/extension | grep pg_bigm | tee -a ${LOGFILE}
    # Must be pg_bigm.so
    info "ls -l ${PGHOME}/lib | grep pg_bigm"
    ls -l ${PGHOME}/lib | grep pg_bigm | tee -a ${LOGFILE}

    # Testing pg_bigm
    info "Testing installation of pg_bigm."
    ${PGBIN}/initdb -D ${version} -E UTF8 --no-locale
    ${PGBIN}/pg_ctl start -D ${version} -w
    cat << EOF | ${PGBIN}/psql -d postgres | tee -a ${LOGFILE}
create extension pg_bigm;
\x+ pg_bigm
create table hoge (c text);
insert into hoge values ('pg_bigmは全文検索モジュール');
insert into hoge values ('pg_trgmは全文検索モジュール');
create index hoge_idx on hoge using gin (c gin_bigm_ops);
set enable_seqscan to off;
explain (costs off) select * from hoge where c like '%pg_bigm%';
EOF
    ${PGBIN}/pg_ctl stop -D ${version} -w
    rm -rf ${version}

    # Unistall postgresql
    info "Uninstalling postgresql"
    sudo yum -y remove postgresql${version1}${version2}*

    # Done
    info "Done"
done

# Complete!!
info "    Complete!!"
