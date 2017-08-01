# pg_bigm_support

## Set up

1. Download pg_bigm_support repository
```
$ git clone git@github.com:MasahikoSawada/pg_bigm_support.git
$ cd pg_bigm_support
```
2. Put source tarball at rpmbuild/SOURCES
```
/* Note that need to rename tarball in pg_bigm case. */
$ tar zxf pg_bigm-1.2-20161011.tar.gz
$ mv pg_bigm-1.2-20161011 pg_bigm-1.2.20161011.tar.gz
$ tar zcf pg_bigm-1.2.20161011.tar.gz pg_bigm-1.2.20161011
/* Put source tarball */ 
$ mv pg_bigm-1.2-20161011.tar.gz rpmbuild/SOURCES/
```
3. Put postgresql rpm file if needed.
This repository has latest version (at Oct 2016) rpm files of PostgresSQL 9.1 to 9.6.
Put following postgresql rpm files to `rpmtest` directory if needed.
  - postgresqlXX-X.X.XX
  - postgresqlXX-devel
  - postgresqlXX-libs
  - postgresqlXX-server

For example,
```
$ mv postgresql91-9.1.23-1PGDG.rhel6.x86_64.rpm rpmtest/9.1/
$ mv postgresql91-devel-9.1.23-1PGDG.rhel6.x86_64.rpm rpmtest/9.1/
$ mv postgresql91-libs-9.1.23-1PGDG.rhel6.x86_64.rpm rpmtest/9.1/
$ mv postgresql91-server-9.1.23-1PGDG.rhel6.x86_64.rpm rpmtest/9.1/
```

## Directory Configuration
After set up, direcotry configuration shoule be as follows.

```
./pg_bigm_support
 ├─ generate_rpm.sh
 ├─ pg_bigm.spec
 ├─ README.md
 ├─　rpmbuild
 │   ├─ BUILD
 │   ├─ BUILDROOT
 │   ├─ SOURCES
 │   │   └─ pg_bigm-1.2-20161011.tar.gz
 │   ├─ SPECS
 │   └─ SRPMS
 └─ rpmtest
     ├─ 9.1
     │   ├─ postgresql91-9.1.23-1PGDG.rhel6.x86_64.rpm
     │   ├─ postgresql91-devel-9.1.23-1PGDG.rhel6.x86_64.rpm
     │   ├─ postgresql91-libs-9.1.23-1PGDG.rhel6.x86_64.rpm
     │   └─ postgresql91-server-9.1.23-1PGDG.rhel6.x86_64.rpm
     ├─ 9.2
     │   ├─ postgresql92-9.2.18-1PGDG.rhel6.x86_64.rpm
     │   ├─ postgresql92-devel-9.2.18-1PGDG.rhel6.x86_64.rpm
     │   ├─ postgresql92-libs-9.2.18-1PGDG.rhel6.x86_64.rpm
     │   └─ postgresql92-server-9.2.18-1PGDG.rhel6.x86_64.rpm
(snip)
```

## Usage
```
$ ./generate_rpm.sh <specfile>
```

### Example
```
$ ./generate_rpm.sh pg_bigm.spec
$ ls rpmbuild/RPMS/x86_64/
pg_bigm-1.2.20161011-1.pg91.el6.x86_64.rpm  pg_bigm-1.2.20161011-1.pg93.el6.x86_64.rpm  pg_bigm-1.2.20161011-1.pg95.el6.x86_64.rpm
pg_bigm-1.2.20161011-1.pg92.el6.x86_64.rpm  pg_bigm-1.2.20161011-1.pg94.el6.x86_64.rpm  pg_bigm-1.2.20161011-1.pg96.el6.x86_64.rpm
```
