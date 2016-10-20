# SPEC file for pg_bigm
# Copyright(C) 2016 NTT DATA CORPORATION

%define version1 XXX
%define version2 YYY

%define _topdir ZZZ
%define _pgdir   /usr/pgsql-%{version1}.%{version2}
# %define _bindir  %{_pgdir}/bin
%define _libdir  %{_pgdir}/lib
%define _datadir %{_pgdir}/share
%if "%(echo ${MAKE_ROOT})" != ""
  %define _rpmdir %(echo ${MAKE_ROOT})/RPMS
  #%define _sourcedir %(echo ${MAKE_ROOT})
%endif

## Set general information for pg_hint_plan.
Summary:    2-gram full text search for PostgreSQL
Name:       pg_bigm
Version:    1.2.20161011
Release:    1.pg%{version1}%{version2}%{?dist}
License:    The PostgreSQL License
Group:      Applications/Databases
Source0:    %{name}-%{version}.tar.gz
URL:        http://pgbigm.sourceforge.jp/index.html
BuildRoot:  %{_tmppath}/%{name}-%{version}-%{release}-%(%{__id_u} -n)
Vendor:     NTT DATA CORPORATION

## We use postgresql-devel package
BuildRequires:  postgresql%{version1}%{version2}-devel
Requires:  postgresql%{version1}%{version2}-libs

## Description for "pg_bigm"
%description
The pg_bigm module provides full text search capability in PostgreSQL.
This module allows a user to create 2-gram (bigram) index for faster full text search.

Note that this package is available for only PostgreSQL %{version1}.%{version2}.

## pre work for build pg_bigm
%prep
PATH=/usr/pgsql-%{version1}.%{version2}/bin:$PATH
if [ "${MAKE_ROOT}" != "" ]; then
  pushd ${MAKE_ROOT}
  make clean %{name}-%{version}.tar.gz
  popd
fi
if [ ! -d %{_rpmdir} ]; then mkdir -p %{_rpmdir}; fi
%setup -q

## Set variables for build environment
%build
PATH=/usr/pgsql-%{version1}.%{version2}/bin:$PATH
make USE_PGXS=1 %{?_smp_mflags}

## Set variables for install
%install
rm -rf %{buildroot}
install -d %{buildroot}%{_libdir}
install pg_bigm.so %{buildroot}%{_libdir}/pg_bigm.so
install -d %{buildroot}%{_datadir}/extension
install -m 644 pg_bigm--1.2.sql %{buildroot}%{_datadir}/extension/pg_bigm--1.2.sql
install -m 644 pg_bigm--1.1--1.2.sql %{buildroot}%{_datadir}/extension/pg_bigm--1.1--1.2.sql
install -m 644 pg_bigm--1.0--1.1.sql %{buildroot}%{_datadir}/extension/pg_bigm--1.0--1.1.sql
install -m 644 pg_bigm.control %{buildroot}%{_datadir}/extension/pg_bigm.control

%clean
rm -rf %{buildroot}

%files
%defattr(0755,root,root)
%{_libdir}/pg_bigm.so
%defattr(0644,root,root)
%{_datadir}/extension/pg_bigm--1.2.sql
%{_datadir}/extension/pg_bigm--1.1--1.2.sql
%{_datadir}/extension/pg_bigm--1.0--1.1.sql
%{_datadir}/extension/pg_bigm.control

# History of pg_bigm
%changelog
* Fri Oct 20 2016 Sawada Masahiko <sawada.mshk@gmail.com>
- Initial cut
