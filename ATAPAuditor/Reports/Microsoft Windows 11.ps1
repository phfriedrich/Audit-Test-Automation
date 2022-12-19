[Report] @{
	Title = "Windows 11 Report"
	ModuleName = "ATAPAuditor"
	BasedOn = @(
		"Security baseline for Microsoft Windows 11, Version: 20H2, Date: 2020-12-17"
		"CIS Microsoft Windows 11 Enterprise Release 21H2 Benchmark, Version: 21H2, Date: 2022-02-14"
		#"Restricted Traffic Limited Functionality Baseline for Microsoft Windows 11, Version: 21H2, Date: 2022-06-18"
		"BSI SiM-08202 Client unter Windows 10, Version: 1, Date: 2017-09-13"
        "Configuration Recommendations for Hardening of Windows 10 Using Built-in Functionalities: Version 1.3, Date: 2021-05-03"
    )
	Sections = @(
		[ReportSection] @{
			Title = "CIS Benchmarks"
			Description = "This section contains all benchmarks from CIS"
			SubSections = @(
				[ReportSection] @{
					Title = 'Registry Settings/Group Policies'
					AuditInfos = Test-AuditGroup "Microsoft Windows 11-CIS-1.0.0#RegistrySettings"
				}
				[ReportSection] @{
					Title = 'User Rights Assignment'
					AuditInfos = Test-AuditGroup "Microsoft Windows 11-CIS-1.0.0#UserRights"
				}
				[ReportSection] @{
					Title = 'Account Policies'
					AuditInfos = Test-AuditGroup "Microsoft Windows 11-CIS-1.0.0#AccountPolicies"
				}
				[ReportSection] @{
					Title = 'Advanced Audit Policy Configuration'
					AuditInfos = Test-AuditGroup "Microsoft Windows 11-CIS-1.0.0#AuditPolicies"
				}
				[ReportSection] @{
					Title = 'Security Options'
					AuditInfos = Test-AuditGroup "Microsoft Windows 11-CIS-1.0.0#SecurityOptions"
				}
			)
		}
		[ReportSection] @{
			Title = "Microsoft Benchmarks"
			Description = "This section contains all benchmarks from Microsoft"
			SubSections = @(
				[ReportSection] @{
					Title = 'Registry Settings/Group Policies'
					AuditInfos = Test-AuditGroup "Microsoft Windows 11-Microsoft-2022#RegistrySettings"
				}
				[ReportSection] @{
					Title = 'User Rights Assignment'
					AuditInfos = Test-AuditGroup "Microsoft Windows 11-Microsoft-2022#UserRights"
				}
				[ReportSection] @{
					Title = 'Account Policies'
					AuditInfos = Test-AuditGroup "Microsoft Windows 11-Microsoft-2022#AccountPolicies"
				}
				[ReportSection] @{
					Title = 'Advanced Audit Policy Configuration'
					AuditInfos = Test-AuditGroup "Microsoft Windows 11-Microsoft-2022#AuditPolicies"
				}
				[ReportSection] @{
					Title = 'Security Options'
					AuditInfos = Test-AuditGroup "Microsoft Windows 11-Microsoft-2022#SecurityOptions"
				}
			)
		}
		# [ReportSection] @{
		# 	Title = "Microsoft Benchmarks Restricted Traffic Limited Functionality Baseline"
		# 	Description = "This section contains all benchmarks from Microsoft RTLFB"
		# 	SubSections = @(
		# 		[ReportSection] @{
		# 			Title = 'Registry Settings/Group Policies'
		# 			AuditInfos = Test-AuditGroup "Microsoft Windows 11 Restricted Traffic Limited Functionality Baseline (Machine)-Microsoft-21H2#RegistrySettings"
		# 		}
		# 		[ReportSection] @{
		# 			Title = 'Registry Settings/Group Policies'
		# 			AuditInfos = Test-AuditGroup "Microsoft Windows 11 Restricted Traffic Limited Functionality Baseline (User)-Microsoft-21H2#RegistrySettings"
		# 		}
		# 	)
		# }
		[ReportSection] @{
			Title = 'BSI Benchmarks SySiPHuS Logging'
			Description = 'This section contains the BSI Benchmark results.'
			SubSections = @(
				[ReportSection] @{
					Title = 'Registry Settings/Group Policies'
					AuditInfos = Test-AuditGroup "Microsoft Windows 10 SiSyPHuS Logging-BSI-1.3#RegistrySettings"
				}
				[ReportSection] @{
					Title = 'Advanced Audit Policy Configuration'
					AuditInfos = Test-AuditGroup "Microsoft Windows 10 SiSyPHuS Logging-BSI-1.3#AuditPolicies"
				}
			)
		}
		[ReportSection] @{
			Title = 'BSI Benchmarks SySiPHuS HD'
			Description = 'This section contains the BSI Benchmark results.'
			SubSections = @(
				[ReportSection] @{
					Title = 'Registry Settings/Group Policies'
					AuditInfos = Test-AuditGroup "Microsoft Windows 10 SiSyPHuS HD-BSI-1.3#RegistrySettings"
				}
				[ReportSection] @{
					Title = 'User Rights Assignment'
					AuditInfos = Test-AuditGroup "Microsoft Windows 10 SiSyPHuS HD-BSI-1.3#UserRights"
				}
				[ReportSection] @{
					Title = 'Account Policies'
					AuditInfos = Test-AuditGroup "Microsoft Windows 10 SiSyPHuS HD-BSI-1.3#AccountPolicies"
				}
				[ReportSection] @{
					Title = 'Security Options'
					AuditInfos = Test-AuditGroup "Microsoft Windows 10 SiSyPHuS HD-BSI-1.3#SecurityOptions"
				}
			)
		}
		[ReportSection] @{
			Title = 'BSI Benchmarks SySiPHuS ND'
			Description = 'This section contains the BSI Benchmark results.'
			SubSections = @(
				[ReportSection] @{
					Title = 'Registry Settings/Group Policies'
					AuditInfos = Test-AuditGroup "Microsoft Windows 10 SiSyPHuS ND-BSI-1.3#RegistrySettings"
				}
				[ReportSection] @{
					Title = 'User Rights Assignment'
					AuditInfos = Test-AuditGroup "Microsoft Windows 10 SiSyPHuS ND-BSI-1.3#UserRights"
				}
				[ReportSection] @{
					Title = 'Account Policies'
					AuditInfos = Test-AuditGroup "Microsoft Windows 10 SiSyPHuS ND-BSI-1.3#AccountPolicies"
				}
				[ReportSection] @{
					Title = 'Security Options'
					AuditInfos = Test-AuditGroup "Microsoft Windows 10 SiSyPHuS ND-BSI-1.3#SecurityOptions"
				}
			)
		}
		[ReportSection] @{
			Title = 'BSI Benchmarks SySiPHuS NE'
			Description = 'This section contains the BSI Benchmark results.'
			SubSections = @(
				[ReportSection] @{
					Title = 'Registry Settings/Group Policies'
					AuditInfos = Test-AuditGroup "Microsoft Windows 10 SiSyPHuS NE-BSI-1.3#RegistrySettings"
				}
				[ReportSection] @{
					Title = 'User Rights Assignment'
					AuditInfos = Test-AuditGroup "Microsoft Windows 10 SiSyPHuS NE-BSI-1.3#UserRights"
				}
				[ReportSection] @{
					Title = 'Account Policies'
					AuditInfos = Test-AuditGroup "Microsoft Windows 10 SiSyPHuS NE-BSI-1.3#AccountPolicies"
				}
				[ReportSection] @{
					Title = 'Security Options'
					AuditInfos = Test-AuditGroup "Microsoft Windows 10 SiSyPHuS NE-BSI-1.3#SecurityOptions"
				}
			)
		}
		# [ReportSection] @{
		# 	Title = 'BSI Benchmarks SiSyPHus-BSI'
		# 	Description = 'This section contains the BSI Benchmark results.'
		# 	SubSections = @(
		# 		[ReportSection] @{
		# 			Title = 'Registry Settings/Group Policies'
		# 			AuditInfos = Test-AuditGroup "Microsoft Windows 10 SiSyPHus-BSI-V1.1#RegistrySettings"
		# 		}
		# 	)
		# }
		# [ReportSection] @{
		# 	Title = 'BSI Benchmarks SiSyPHus-BSI Bundespolizei'
		# 	Description = 'This section contains the BSI Benchmark results.'
		# 	SubSections = @(
		# 		[ReportSection] @{
		# 			Title = 'Registry Settings/Group Policies'
		# 			AuditInfos = Test-AuditGroup "Microsoft Windows 10-BSI-Bundespolizei#RegistrySettings"
		# 		}
		# 		[ReportSection] @{
		# 			Title = 'User Rights Assignment'
		# 			AuditInfos = Test-AuditGroup "Microsoft Windows 10-BSI-Bundespolizei#UserRights"
		# 		}
		# 		[ReportSection] @{
		# 			Title = 'Account Policies'
		# 			AuditInfos = Test-AuditGroup "Microsoft Windows 10-BSI-Bundespolizei#AccountPolicies"
		# 		}
		# 		[ReportSection] @{
		# 			Title = 'Advanced Audit Policy Configuration'
		# 			AuditInfos = Test-AuditGroup "Microsoft Windows 10-BSI-Bundespolizei#AuditPolicies"
		# 		}
		# 	)
		# }
	)
}
