## Other considerations
*e.g. when making a choice between software- or hardware- or cloud- HSM.*

#### Available tooling:
  * Api, library/driver, gui, cli, cloud-integration
  * Configurable by you? or as-is product?
  * Fitting prefered tooling at your organisatien (e.g. OpenDNSSEC, BIND)
  * Public (api-accessible?) repo vs. sign-in required
  * Tooling available for OS(version) we want? packaged or unicorn-install?
  * Version information available? How are new versions communicated?

#### Backup:
  * Included or "left as an exercise"
  * Is restore possible in a safe manner?

#### Capacity:
  * FIPS and other certifications
  * Number of keys
  * Number of partitions
  * Which signing algorithms
  * Signatures per second
  * Time to create, sign and publish zone

#### Company policy/image:
  * "best proven technology"
  * "promote open source"
  * delivers "Trust", befitting your company goal and public image.
  * Keep up in-house DNSSEC expertise, autonomy

#### Continuity:
  * HSM functionality networked or not
  * Key synchronization
  * Load balancing / High Availability / Active-Active
  * Maintenance possible without interrupting service?
  * Feasability of an exit or a switch to another supplier

#### Costs:
  * Deprecation, expected/limited life time, sustainability
  * Surcharges
  * Finance tools, predictable costs?
  * Licences, licence type, licences that could be blocking when scaling?

#### Disaster recovery and prevention:
  * Roll out in phases possible?
  * Geographical "spreadedness"
  * Keys importable / exportable.
  * Fitting offline KSK scenario
  * Protection against power faillure etc.
  * Roll-backs for upgrades?
  * Time between disaster and recovery
  * Upgrades available to us or automatic updates behind the scenes in the cloud?
  * Upgrades and patches testable in acceptance?
  * Backup keys in physical device in your political region?

#### Marketability:
  * Can be used by other internal users for signing / encryption / decryption
  * Surplus capacity can be made available to 3rd party?

#### Monitoring:
  * Alerting, or alerting tool of our choice
  * Metrics, logs, snmp, splunk/influx/prometheus-agent

#### Risks:
  * Scaling, what if you need more?
  * "(changes in) public opinion"-proof?
  * Are you mostly in control? e.g. is it clear what happened to the hsm and/or its functionality last (insert_time_period)?)
  * Future-proof maintenance, not end-of-life product
  * Proven technology or not
  * Solitary maintainer, uncooperative maintainer
  * Spare parts
  * Unwanted hosting party access, agency access

#### Security:
  * How are incidents and patches communicated?
  * Isolation tennants/partitions
  * Key-logger protection (e.g. PEDs) between keyboard and cryptomodule
  * Secure/encrypted communication between all parts.
  * Security patches, clear patch process
  * Auditability, audit trail
  * Lockable, auto-locking
  * Login access to the appliance or software for operations like adding users.
  * M of N based authentication
  * Password based access to HSM functionalities vs. certificate or token based
  * Physical anti-theft
  * Potential for 3rd party access
  * Role based access
  * Secure wipe of keys (decommission)
  * Small or bigger attack surface? lowest number of services/open ports?
  * Tamperproofness

#### Support:
  * Do we get premium support or are we "just one of many customers".
  * Documentation/education available to keep you up-to-date? Best practise guides?
  * Help available, and under what conditions? 24x7x356? How fast?
  * Can bugfixes be submitted in an acceptable way, and will they be acted upon?
  * On-line knowledge base, or all questions "call support"
  * Open source, code accessible
  * Support "more or less in person" or ticketing

[Next](https://github.com/niek-sidn/hsm_workshop_nethsm/blob/main/Slide06.md)

