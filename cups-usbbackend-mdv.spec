%define git_repo cups-usbbackend
%define git_head HEAD

%define name cups-backend-usb2
%define version 0.2
%define release %mkrel 1

Name:		%{name}
Version:	%{version}
Release:	%{release}
Summary:	CUPS alternative USB backend
Group:		System/Servers
License:	GPL
Source0:	%{name}-%{version}.tar.gz

BuildRequires: cups-devel
Requires: cups-common
Requires: udev

%description
The alternative USB backend will be able to select printers
by their serial number or other properties, based on udev rules.

This allows having many identical printers, where their manufacturer
ieee1284 id is the same.


%prep
%git_get_source
%setup -q

%build
%make

%install
[ -n "%{buildroot}" -a "%{buildroot}" != / ] && rm -rf %{buildroot}
install -d %{buildroot}%{_sysconfdir}/udev/rules.d \
	%{buildroot}%{_libdir}/cups/backend
install -D udev-rules.d/* %{buildroot}%{_sysconfdir}/udev/rules.d
install usb2 %{buildroot}%{_libdir}/cups/backend

%clean
[ -n "%{buildroot}" -a "%{buildroot}" != / ] && rm -rf %{buildroot}

%post
/sbin/udevcontrol reload_rules


%files
%defattr(-,root,root)
%config(noreplace)	%{_sysconfdir}/udev/rules.d/*
%attr(0755,root,root)	%{_libdir}/cups/backend/usb2

