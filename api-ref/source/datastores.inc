.. -*- rst -*-

========================
Data stores (datastores)
========================

Lists data store versions, lists parameters for data stores, and
shows parameter details for a data store version.


Show configuration parameter details
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. rest_method::  GET /v1.0/{project_id}/datastores/versions/{datastore_version_id}/parameters/{parameter_name}

Displays details for a configuration parameter associated with a data store
version.

Details include the type, minimum and maximum values, and whether
you must restart the instance after you change the parameter value.

Normal response codes: 200

Error response codes: badRequest(400), unauthorized(401), forbidden(403),
itemNotFound(404), badMethod(405), overLimit(413), unprocessableEntity(422),
instanceFault(500), notImplemented(501), serviceUnavailable(503)


Request
-------

.. rest_parameters:: parameters.yaml

   - parameter_name: parameter_name
   - datastore_version_id: datastore_version_id
   - project_id: project_id


Response Example
----------------

.. literalinclude:: samples/db-show-parameter-details.json
   :language: javascript




List datastore versions
~~~~~~~~~~~~~~~~~~~~~~~

.. rest_method::  GET /v1.0/{project_id}/datastores/{datastore_name}/versions

Lists the available versions of a data store.

Normal response codes: 200

Error response codes: badRequest(400), unauthorized(401), forbidden(403),
itemNotFound(404), badMethod(405), overLimit(413), unprocessableEntity(422),
instanceFault(500), notImplemented(501), serviceUnavailable(503)


Request
-------

.. rest_parameters:: parameters.yaml

   - datastore_name: datastore_name
   - project_id: project_id


Response Example
----------------

.. literalinclude:: samples/db-list-datastore-versions.json
   :language: javascript




List configuration parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. rest_method::  GET /v1.0/{project_id}/datastores/versions/{datastore_version_id}/parameters

Lists the available configuration parameters for a data store version.

Parameter information includes the type, minimum and maximum
values, and whether you must restart the instance after you change
a parameter value.

Normal response codes: 200

Error response codes: badRequest(400), unauthorized(401), forbidden(403),
itemNotFound(404), badMethod(405), overLimit(413), unprocessableEntity(422),
instanceFault(500), notImplemented(501), serviceUnavailable(503)


Request
-------

.. rest_parameters:: parameters.yaml

   - datastore_version_id: datastore_version_id
   - project_id: project_id


Response Example
----------------

.. literalinclude:: samples/db-list-parameters-response.json
   :language: javascript
