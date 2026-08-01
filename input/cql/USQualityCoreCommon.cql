/*
@description: Common terminologies and functions used in USQualityCore-based CQL artifacts
@comment: This version is a draft of the updates needed to go from USQualityCore 0.5.0 to 1.0.0-ballot
This version was started from the 0.5.0 published USQualityCoreCommon.
It adds extension access support for all the extensions introduced in v1.0.0
*/
library USQualityCoreCommon version '3.0.0-draft'

using USQualityCore version '1.0.0-ballot'

include hl7.fhir.uv.cql.FHIRHelpers version '4.0.1'
include hl7.fhir.uv.cql.FHIRCommon version '2.0.0'

codesystem "ActCode": 'http://terminology.hl7.org/CodeSystem/v3-ActCode'
codesystem "TaskCodeSystem": 'http://hl7.org/fhir/CodeSystem/task-code'

// Encounter Class Codes
code "ambulatory": 'AMB' from ActCode display 'ambulatory'
code "emergency": 'EMER' from ActCode display 'emergency'
code "field": 'FLD' from ActCode display 'field'
code "home health": 'HH' from ActCode display 'home health'
code "inpatient encounter": 'IMP' from ActCode display 'inpatient encounter'
code "inpatient acute": 'ACUTE' from ActCode display 'inpatient acute'
code "inpatient non-acute": 'NONAC' from ActCode display 'inpatient non-acute'
code "observation encounter": 'OBSENC' from ActCode display 'observation encounter'
code "pre-admission": 'PRENC' from ActCode display 'pre-admission'
code "short stay": 'SS' from ActCode display 'short stay'
code "virtual": 'VR' from ActCode display 'Virtual'

//Task codes
code "Fulfill": 'fulfill' from "TaskCodeSystem" display 'Fulfill'

context Patient

/*
@description: Returns the id of the given uri (i.e. everything after the last slash)
*/
define fluent function getId(uri String):
  Last(Split(uri, '/'))

/*
@description: Returns the System.ValueSet instance with the url and version (if present) of the given canonical reference
*/
define fluent function toValueSet(canonical FHIR.canonical):
  System.ValueSet {
    id: canonical.url(),
    version: canonical.version()
  }

/*
@description: Converts the activity extent pattern used to represent possible activities to either a codeableConcept or a value set
@seealso: [Negation In US Quality Core](http://hl7.org/fhir/us/quality-core/negation.html)
*/
define fluent function toActivityExtent(codeableConcept FHIR.CodeableConcept):
  (codeableConcept.ext('http://hl7.org/fhir/StructureDefinition/codeOptions').value) X
    return
      if X is not null
        then X.toValueSet()
        else codeableConcept

/*
@description: Returns the value of the recorded extension for a CommunicationNotDone
*/
define fluent function recorded(communicationNotDone CommunicationNotDone):
  communicationNotDone.ext('http://hl7.org/fhir/StructureDefinition/event-recorded').value as FHIR.dateTime

/*
@description: Returns the activity extent for a Communication
@seealso: [Negation In US Quality Core](http://hl7.org/fhir/us/quality-core/negation.html)
*/
define fluent function topic(communication Communication):
  communication.topic.toActivityExtent()

/*
@description: Returns the value of the doNotPerform extension for a Device Prohibited
*/
define fluent function doNotPerform(deviceProhibited DeviceProhibited):
  deviceProhibited.ext('http://hl7.org/fhir/5.0/StructureDefinition/extension-DeviceRequest.doNotPerform').value as FHIR.boolean

/*
@description: Returns the activity extent for a DeviceRequest
@seealso: [Negation In US Quality Core](http://hl7.org/fhir/us/quality-core/negation.html)
*/
define fluent function code(deviceRequest DeviceRequest):
  deviceRequest.code.toActivityExtent()

/*
@description: Returns the value of the abatement extension for a FamilyMemberHistory
*/
define fluent function abatement(familyMemberHistory FHIR.FamilyMemberHistory):
  familyMemberHistory.ext('hl7.org/fhir/StructureDefinition/familymemberhistory-abatement').value as Choice<FHIR.date, FHIR.Age, FHIR.boolean>

/*
@description: Returns the value of the severity extension for a FamilyMemberHistory
*/
define fluent function severity(familyMemberHistory FHIR.FamilyMemberHistory):
  familyMemberHistory.ext('hl7.org/fhir/StructureDefinition/familymemberhistory-severity').value as FHIR.CodeableConcept

/*
@description: Returns the activity extent for an Immunization
@seealso: [Negation In US Quality Core](http://hl7.org/fhir/us/quality-core/negation.html)
*/
define fluent function vaccineCode(immunization Immunization):
  immunization.vaccineCode.toActivityExtent()

/*
@description: Returns the activity extent for a MedicationAdministration
@seealso: [Negation In US Quality Core](http://hl7.org/fhir/us/quality-core/negation.html)
*/
define fluent function medication(medicationAdministration MedicationAdministration):
  medicationAdministration.medication.toActivityExtent()

/*
@description: Returns the value of the recorded extension for a Medication Dispense Declined
*/
define fluent function recorded(medicationDispenseDeclined MedicationDispenseDeclined):
  medicationDispenseDeclined.ext('http://hl7.org/fhir/5.0/StructureDefinition/extension-MedicationDispense.recorded').value as FHIR.dateTime

/*
@description: Returns the activity extent for a MedicationDispense
@seealso: [Negation In US Quality Core](http://hl7.org/fhir/us/quality-core/negation.html)
*/
define fluent function medication(medicationDispense MedicationDispense):
  (medicationDispense.medication as FHIR.CodeableConcept).toActivityExtent()

/*
@description: Returns the activity extent for a MedicationRequest
@seealso: [Negation In US Quality Core](http://hl7.org/fhir/us/quality-core/negation.html)
*/
define fluent function medication(medicationRequest MedicationRequest):
  medicationRequest.medication.toActivityExtent()

/*
@description: Returns the value of the recorded extension for a Procedure
*/
define fluent function recorded(procedure Procedure):
  procedure.ext('http://hl7.org/fhir/5.0/StructureDefinition/extension-Procedure.recorded').value as FHIR.dateTime

/*
@description: Returns the activity extent for a Procedure
@seealso: [Negation In US Quality Core](http://hl7.org/fhir/us/quality-core/negation.html)
*/
define fluent function code(procedure Procedure):
  procedure.code.toActivityExtent()

/*
@description: Returns the activity extent for a Service Request
@seealso: [Negation In US Quality Core](http://hl7.org/fhir/us/quality-core/negation.html)
*/
define fluent function code(serviceRequest ServiceRequest):
  serviceRequest.code.toActivityExtent()

/*
@description: Returns the activity extent for a Task
@seealso: [Negation In US Quality Core](http://hl7.org/fhir/us/quality-core/negation.html)
*/
define fluent function code(task FHIR.Task):
  task.code.toActivityExtent()

/*
@description: Creates a list of integers from 1 to how many days are in the interval. Note, this wont create an index for
the final day if it is less than 24 hours. This also includes the first 24 hour period.
*/
define fluent function toDayNumbers(Period Interval<DateTime>):
  ( expand { Interval[1, duration in days between start of Period and end of Period]} ) DayNumber
    return end of DayNumber

/*
@description: Creates a list of 24 hour long intervals in an interval paired with the index (1 indexed) to which 24 hour interval it is.
Note that the result will include intervals that are closed at the beginning and open at the end
*/
define fluent function daysInPeriod(Period Interval<DateTime>):
  ( Period.toDayNumbers()) DayIndex
    let startPeriod: start of Period + (24 hours * (DayIndex - 1)),
    endPeriod: if (hours between startPeriod and end of Period < 24) then startPeriod
      else start of Period + (24 hours * DayIndex)
    return Tuple {
      dayIndex: DayIndex,
      dayPeriod: Interval[startPeriod, endPeriod)
    }

/*
@description: Returns the value of the presentOnAdmission extension
*/
define fluent function presentOnAdmission(diagnosis USQualityCore."Encounter.Diagnosis"):
  diagnosis.ext('http://hl7.org/fhir/us/quality-core/StructureDefinition/us-quality-core-diagnosis-present-on-admission').value as FHIR.CodeableConcept