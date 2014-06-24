cycle = (iterable) ->
  unless _.isArray iterable
    iterable = _.keys iterable
  index = 0
  ->
    element = iterable[index]
    index = (index + 1) % iterable.length
    element


firstWords = cycle _.shuffle [
  'Legendblood'
  'Dungeon Delver'
  'Valiant'
  'Fire Wizard'
  'Temple Raider'
  'Shadowcaster'
  'Ruin Mapper'
  'Psionic Artificer'
  'Necromancer'
  'Quest-Taker'
  'Tomb Looter'
  'Axemage'
  'Barbarian'
  'Paladin of Tyranny'
  'Dragon Knight'
  'Warlord'
  'Sorcerer'
  'Beserker'
  'Druid'
  'Battle Priest'
  'Beastmaster'
  'Alchemist'
]


secondWords = cycle _.shuffle [
  'Clarke'
  'Patel'
  'Adams'
  'Khan'
  'Harris'
  'Chapman'
  'Davis'
  'Cunningham'
  'Jones'
  'Smith'
  'Taylor'
  'Williams'
  'Brown'
  'Jenkins'
  'Davies'
  'Evans'
  'Wilson'
  'Roberts'
  'Watson'
]


thirdWords = cycle _.shuffle [
  'Accounting Vice President'
  'Accounts Supervisor'
  'Assistant Director of Finance'
  'Assistant Director of Financial Operations'
  'Audit Supervisor'
  'Auditor'
  'Bookkeeper'
  'Budget Analyst'
  'Budget Manager'
  'Bursar'
  'Certified Public Accountant'
  'Chief Accounting Officer'
  'Chief Financial Officer'
  'Compliance Auditor'
  'Contracts and Financial Compliance Manager'
  'Controller'
  'Corporate Accountant'
  'Cost Accountant'
  'Director of Financial Operations'
  'Environmental Auditor'
  'External Auditor'
  'Financial Analyst'
  'Financial Assurance Manager'
  'Financial Assurance Specialist'
  'Forensic Accountant'
  'Gift Administration Specialist'
  'Gift Assurance Officer'
  'Government Accountant'
  'Government Auditor'
  'Grants and Contracts Assistant'
  'Grants and Contracts Specialist'
  'Industrial Accountant'
  'Information Technology Audit Manager'
  'Information Technology Auditor'
  'Internal Auditor'
  'Management Accountant'
  'Managerial Accountant'
  'Payroll Manager'
  'Payroll Services Analyst'
  'Private Accountant'
  'Public Accountant'
  'Revenue Cycle Administrator'
  'Revenue Cycle Manager'
  'Revenue Cycle Supervisor'
  'Senior Auditor'
  'Senior Budget Analyst'
  'Senior Cash Management Analyst'
  'Senior Financial Analyst'
  'Senior General Audit Manager'
  'Senior Gift Assurance Officer'
  'Senior Grants and Contracts Specialist'
  'Senior Strategic Planner'
  'Staff Accountant'
  'Staff Auditor'
  'Strategic Planner'
  'Strategic Planning and Institutional Analysis Manager'
  'Strategic Program Planning Advisor'
  'Tax Accountant'
  'Tax Specialist'
]

@generateName = ->
  "#{ firstWords() } #{ secondWords() } the #{ thirdWords() }"

